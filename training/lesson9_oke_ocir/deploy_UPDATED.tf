module "fk_ocir" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-ocir.git?ref=v0.1.0"

  compartment_ocid = var.compartment_ocid
  repository_name  = format("%s/%s", var.ocir_repo_name, var.ocir_repo_name)
  region           = var.region
}

resource "local_file" "nginx_deployment" {
  content = templatefile("${path.module}/manifest/nginx.template.yaml", {
    number_of_nginx_replicas = var.number_of_nginx_replicas
    image_url                = module.fk_ocir.latest_image
    is_arm_node_shape        = local.is_arm_node_shape
  })
  filename = "${path.module}/nginx.yaml"
}

resource "local_file" "service_deployment" {
  content = templatefile("${path.module}/manifest/service.template.yaml", {
    lb_shape                      = var.lb_shape
    flex_lb_min_shape             = var.flex_lb_min_shape
    flex_lb_max_shape             = var.flex_lb_max_shape
    lb_listener_port              = var.lb_listener_port
    lb_nsg                        = var.lb_nsg
    lb_nsg_id                     = var.lb_nsg ? module.fk_nsg_lb[0].nsg_id : ""
    use_reserved_public_ip_for_lb = var.use_reserved_public_ip_for_lb
    reserved_public_ip_for_lb     = var.use_reserved_public_ip_for_lb ? module.fk_public_ip_lb[0].ip_address : ""
  })
  filename = "${path.module}/service.yaml"
}

resource "local_file" "indexhtml_deployment" {
  content = templatefile("${path.module}/manifest/index.template.html", {
    image_url = module.fk_ocir.latest_image
  })
  filename = "${path.module}/index.html"
}

resource "local_file" "dockerfile_deployment" {
  content  = templatefile("${path.module}/manifest/dockerfile.template", {})
  filename = "${path.module}/dockerfile"
}

resource "null_resource" "deploy_to_ocir" {
  depends_on = [
    module.fk-oke.cluster,
    module.fk-oke.node_pool,
    module.fk_ocir,
    local_file.nginx_deployment,
    local_file.service_deployment,
    local_file.indexhtml_deployment,
    local_file.dockerfile_deployment,
  ]

  provisioner "local-exec" {
    command = "echo '${var.ocir_user_password}' | docker login ${module.fk_ocir.registry} --username ${module.fk_ocir.namespace}/${var.ocir_user_name} --password-stdin"
  }

  provisioner "local-exec" {
    command = "image=$(docker images | grep fknginx | awk -F ' ' '{print $3}') ; docker rmi -f $image &> /dev/null ; echo $image"
  }

  provisioner "local-exec" {
    command = "docker build -t fknginx ."
  }

  provisioner "local-exec" {
    command = "image=$(docker images | grep fknginx | awk -F ' ' '{print $3}') ; docker tag $image ${module.fk_ocir.latest_image}"
  }

  provisioner "local-exec" {
    command = "docker push ${module.fk_ocir.latest_image}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "image=$(docker images | grep fknginx | awk -F ' ' '{print $3}') ; docker rmi -f $image &> /dev/null ; echo $image"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf dockerfile"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf index.html"
  }
}

resource "null_resource" "deploy_oke_nginx" {
  depends_on = [
    null_resource.deploy_to_ocir,
    module.fk-oke.cluster,
    module.fk-oke.node_pool,
    local_file.nginx_deployment,
    local_file.service_deployment,
  ]

  provisioner "local-exec" {
    command = "oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${module.fk-oke.cluster.id}"
  }

  provisioner "local-exec" {
    command = "kubectl create secret docker-registry ocirsecret --docker-server=${module.fk_ocir.registry} --docker-username='${module.fk_ocir.namespace}/${var.ocir_user_name}' --docker-password='${var.ocir_user_password}' --docker-email='${var.ocir_user_email}' "
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.nginx_deployment.filename} --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.service_deployment.filename}"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "local-exec" {
    command = "kubectl get pods"
  }

  provisioner "local-exec" {
    command = "kubectl get services"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete service lb-service"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf service.yaml"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf nginx.yaml"
  }
}
