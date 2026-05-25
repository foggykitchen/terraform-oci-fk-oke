module "fk_filestorage" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-filestorage.git?ref=v0.1.0"

  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0].name : var.availablity_domain_name
  name                = "foggykitchen-fss"
  subnet_id           = module.fk_vcn.subnet_ids["nodes"]

  mount_target = {
    display_name = "FoggyKitchenMountTarget"
    ip_address   = var.mount_target_ip_address
  }

  file_systems = {
    shared = {
      display_name = "FoggyKitchenFilesystem"
    }
  }

  exports = {
    shared = {
      file_system_key = "shared"
      path            = var.file_storage_export_path
    }
  }
}
