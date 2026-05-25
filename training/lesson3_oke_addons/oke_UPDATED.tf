module "fk-oke" {
  providers                     = { oci = oci.targetregion }
  source                        = "../.."
  tenancy_ocid                  = var.tenancy_ocid
  compartment_ocid              = var.compartment_ocid
  cluster_type                  = "enhanced"
  k8s_version                   = "v1.35.2"
  node_linux_version            = "8.10"
  oci_vcn_ip_native             = true
  vcn_native                    = true
  use_existing_vcn              = true
  use_existing_nsg              = false
  vcn_id                        = module.fk-vcn.vcn_id
  api_endpoint_subnet_id        = module.fk-vcn.subnet_ids["api_endpoint"]
  lb_subnet_id                  = module.fk-vcn.subnet_ids["lb"]
  nodepool_subnet_id            = module.fk-vcn.subnet_ids["nodes"]
  pods_subnet_id                = module.fk-vcn.subnet_ids["nodes"]
  is_api_endpoint_subnet_public = true  # OKE API Endpoint will be public (Internet facing)
  is_lb_subnet_public           = true  # OKE LoadBalanacer will be public (Internet facing)
  is_nodepool_subnet_public     = false # OKE NodePool will be private (not-Internet facing)
  
  fk_oke_addon_map = {
    CertManager = {
      configurations = {
        numOfReplicas = {
          config_value = "1"
        }
      }
      addon_version = "v1.16.1"
    }
    OracleDatabaseOperator = {
      configurations = {
        numOfReplicas = {
          config_value = "1"
        }
      }
      addon_version = "v1.1.0"
    }
  }
}
