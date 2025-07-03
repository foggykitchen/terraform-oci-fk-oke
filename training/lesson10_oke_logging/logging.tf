resource "oci_logging_log_group" "oke_log_group" {
    compartment_id = var.compartment_ocid
    display_name = "oke_log_group"
    description = "Logging Group for OKE logs"
}

resource "oci_logging_log" "oke_log" {
  display_name = "oke_log"
  log_group_id = oci_logging_log_group.oke_log_group.id
  log_type = "SERVICE"

  configuration {
    source {
      category = "all-service-logs"
      service = "oke-k8s-cp-prod"
      source_type = "OCISERVICE"
      resource = module.fk-oke.cluster.id
    }
    compartment_id = var.compartment_ocid
  }
  is_enabled = true
}