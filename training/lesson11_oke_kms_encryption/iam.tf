module "fk_policy_oke_kms" {
  providers = {
    oci = oci.homeregion
  }

  source = "github.com/foggykitchen/terraform-oci-fk-policy"

  tenancy_ocid = var.tenancy_ocid

  policies = [
    {
      name        = "fk_oke_kms_secret_encryption"
      description = "Policy to allow OKE clusters to use the Vault key for Kubernetes secret encryption"
      statements = [
        "Allow any-user to use keys in compartment id ${var.compartment_ocid} where ALL {request.principal.type = 'cluster', target.key.id = '${module.fk-vault.key_ids["oke-secrets"]}'}"
      ]
    }
  ]
}
