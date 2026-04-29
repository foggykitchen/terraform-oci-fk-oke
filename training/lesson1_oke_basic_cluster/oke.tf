module "fk-oke" {
  source                        = "../.."
  tenancy_ocid                  = var.tenancy_ocid     # Our tenancy OCID     
  compartment_ocid              = var.compartment_ocid # Compartment OCID where OKE and network will be deployed
  cluster_type                  = "basic"              # Basic cluster
  k8s_version                   = "v1.35.2"
  node_linux_version            = "8.10"
  node_shape                    = "VM.Standard.A1.Flex" # OCI Free Tier
  node_ocpus                    = 1                     # OCI Free Tier
  node_memory                   = 4                     # OCI Free Tier
  use_existing_vcn              = true
  use_existing_nsg              = false
  vcn_id                        = module.fk-vcn.vcn_id
  api_endpoint_subnet_id        = module.fk-vcn.subnet_ids["api_endpoint"]
  lb_subnet_id                  = module.fk-vcn.subnet_ids["lb"]
  nodepool_subnet_id            = module.fk-vcn.subnet_ids["nodes"]
  is_api_endpoint_subnet_public = true
  is_lb_subnet_public           = true
  is_nodepool_subnet_public     = true
}
