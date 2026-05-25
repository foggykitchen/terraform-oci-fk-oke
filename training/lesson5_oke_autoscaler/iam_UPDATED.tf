module "fk_policy_autoscaler_workload_identity_principal" {
  source = "github.com/foggykitchen/terraform-oci-fk-policy"

  providers = {
    oci = oci.homeregion
  }

  enabled      = var.autoscaler_authtype_workload
  tenancy_ocid = var.tenancy_ocid

  policies = [
    {
      name        = "fk_oke_autoscaler_policy_workload_identity_principal"
      description = "Policy to enable OKE Cluster Autoscaler (Workload identity principal)"
      statements = [
        "Allow any-user to manage cluster-node-pools in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
        "Allow any-user to manage instance-family in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
        "Allow any-user to use subnets in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
        "Allow any-user to read virtual-network-family in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
        "Allow any-user to use vnics in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
        "Allow any-user to inspect compartments in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}"
      ]
    }
  ]
}

module "fk_policy_autoscaler_instance_principal" {
  source = "github.com/foggykitchen/terraform-oci-fk-policy"

  providers = {
    oci = oci.homeregion
  }

  enabled      = !var.autoscaler_authtype_workload
  tenancy_ocid = var.tenancy_ocid

  dynamic_group = {
    name          = "fk_oke_autoscaler_dg"
    description   = "Dynamic group for OKE Cluster Autoscaler (Instance principal)"
    matching_rule = "ALL {instance.compartment.id ='${var.compartment_ocid}'}"
  }

  policies = [
    {
      name        = "fk_oke_autoscaler_policy_instance_principal"
      description = "Policy to enable OKE Cluster Autoscaler (Instance principal)"
      statements = [
        "Allow dynamic-group fk_oke_autoscaler_dg to manage cluster-node-pools in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_oke_autoscaler_dg to manage instance-family in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_oke_autoscaler_dg to use subnets in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_oke_autoscaler_dg to read virtual-network-family in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_oke_autoscaler_dg to use vnics in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_oke_autoscaler_dg to inspect compartments in compartment id ${var.compartment_ocid}"
      ]
    }
  ]
}
