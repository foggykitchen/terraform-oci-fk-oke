module "fk_block_volume" {
  count  = var.pvc_from_existing_block_volume ? 1 : 0
  source = "github.com/foggykitchen/terraform-oci-fk-blockvolume"

  name                = var.block_volume_name
  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0].name : var.availablity_domain_name
  size_in_gbs         = var.block_volume_size
  vpus_per_gb         = var.vpus_per_gb
}
