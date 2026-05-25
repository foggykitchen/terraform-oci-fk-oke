module "fk_logging" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-logging.git?ref=v0.1.0"

  compartment_ocid      = var.compartment_ocid
  log_group_name        = "oke_log_group"
  log_group_description = "Logging Group for OKE logs"

  service_logs = {
    oke_control_plane = {
      display_name = "oke_log"
      source = {
        category = "all-service-logs"
        service  = "oke-k8s-cp-prod"
        resource = module.fk-oke.cluster.id
      }
    }
  }
}
