module "fk_policy_adbs_instance_principal" {
  source = "github.com/foggykitchen/terraform-oci-fk-policy"

  providers = {
    oci = oci.homeregion
  }

  enabled      = var.deploy_adbs
  tenancy_ocid = var.tenancy_ocid

  dynamic_group = {
    name          = "fk_oke_instance_principal_dg"
    description   = "Dynamic group for OKE worker nodes provisioning Autonomous Database"
    matching_rule = "ALL {instance.compartment.id='${var.compartment_ocid}'}"
  }

  policies = [
    {
      name        = "fk_oke_adbs_identity_principal"
      description = "Policy to enable fk_oke_instance_principal_dg to manage Autonomous Database and read OCI Vaults"
      statements = [
        "Allow dynamic-group fk_oke_instance_principal_dg to manage autonomous-database in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_oke_instance_principal_dg to manage autonomous-backup in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_oke_instance_principal_dg to read vaults in compartment id ${var.compartment_ocid}"
      ]
    }
  ]
}
