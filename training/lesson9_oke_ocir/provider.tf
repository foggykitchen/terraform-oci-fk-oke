terraform {
  required_version = ">= 1.11.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 9.12.1, < 10.0.0"
    }
  }
}

provider "oci" {
  alias            = "targetregion"
  tenancy_ocid     = var.tenancy_ocid
  region           = var.region
  fingerprint      = var.fingerprint
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
}
