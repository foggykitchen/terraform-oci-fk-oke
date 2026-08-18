module "fk-vault" {
  providers = { oci = oci.targetregion }
  source    = "git::https://github.com/foggykitchen/terraform-oci-fk-vault.git?ref=main"

  name             = "fk-oke-kms-vault"
  compartment_ocid = var.compartment_ocid
  vault_type       = "DEFAULT"

  keys = {
    oke-secrets = {
      display_name    = "fk-oke-secrets-key"
      protection_mode = "SOFTWARE"
      key_shape = {
        algorithm = "AES"
        length    = 32
      }
    }
  }
}
