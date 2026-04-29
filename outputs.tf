output "cluster" {
  value = {
    id                 = oci_containerengine_cluster.fk_oke_cluster.id
    kubernetes_version = oci_containerengine_cluster.fk_oke_cluster.kubernetes_version
    name               = oci_containerengine_cluster.fk_oke_cluster.name
  }
}

output "node_pool" {
  value = {
    id                 = var.virtual_node_pool ? oci_containerengine_virtual_node_pool.fk_oke_virtual_node_pool[*].id : oci_containerengine_node_pool.fk_oke_node_pool[*].id
    kubernetes_version = var.virtual_node_pool ? oci_containerengine_virtual_node_pool.fk_oke_virtual_node_pool[*].kubernetes_version : oci_containerengine_node_pool.fk_oke_node_pool[*].kubernetes_version
    name               = var.virtual_node_pool ? oci_containerengine_virtual_node_pool.fk_oke_virtual_node_pool[*].display_name : oci_containerengine_node_pool.fk_oke_node_pool[*].name
    nodes              = var.virtual_node_pool ? null : oci_containerengine_node_pool.fk_oke_node_pool[*].nodes[*].private_ip
  }
}

output "chosen_node_shape_and_image" {
  value = {
    image_id    = local.selected_image_id
    source_name = local.selected_image_name
  }
}

output "KubeConfig" {
  value = data.oci_containerengine_cluster_kube_config.KubeConfig.content
}

output "oke_cluster_addons" {
  value = data.oci_containerengine_addons.fk_oke_cluster_addons
}

output "oke_addon_options" {
  value = data.oci_containerengine_addon_options.fk_oke_addon_options
}
