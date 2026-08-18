module "fk-oke" {
  providers = { oci = oci.targetregion }

  source = "../.."

  tenancy_ocid                  = var.tenancy_ocid
  region                        = var.region
  compartment_ocid              = var.compartment_ocid
  cluster_type                  = "enhanced"
  k8s_version                   = var.kubernetes_version
  node_linux_version            = var.node_linux_version
  node_pool_count               = 1
  node_count                    = var.node_pool_size
  oci_vcn_ip_native             = true
  vcn_native                    = true
  use_existing_vcn              = true
  use_existing_nsg              = false
  vcn_id                        = module.fk-vcn.vcn_id
  api_endpoint_subnet_id        = module.fk-vcn.subnet_ids["api_endpoint"]
  lb_subnet_id                  = module.fk-vcn.subnet_ids["lb"]
  nodepool_subnet_id            = module.fk-vcn.subnet_ids["nodes"]
  pods_subnet_id                = module.fk-vcn.subnet_ids["nodes"]
  is_api_endpoint_subnet_public = true
  is_lb_subnet_public           = true
  is_nodepool_subnet_public     = false
  kms_key_id                    = module.fk-vault.key_ids["oke-secrets"]

  depends_on = [module.fk_policy_oke_kms]
}
