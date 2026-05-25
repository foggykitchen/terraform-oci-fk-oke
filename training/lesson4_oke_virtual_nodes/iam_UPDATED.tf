module "fk_policy_virtual_node_pool" {
  source = "github.com/foggykitchen/terraform-oci-fk-policy"

  providers = {
    oci = oci.homeregion
  }

  tenancy_ocid = var.tenancy_ocid

  policies = [
    {
      name        = "fk_oke_virtual_node_pool_policy"
      description = "Required IAM policy for using virtual nodes in OKE clusters"
      statements = [
        "define tenancy ske as ocid1.tenancy.oc1..aaaaaaaacrvwsphodcje6wfbc3xsixhzcan5zihki6bvc7xkwqds4tqhzbaq",
        "define compartment ske_compartment as ocid1.compartment.oc1..aaaaaaaa2bou6r766wmrh5zt3vhu2rwdya7ahn4dfdtwzowb662cmtdc5fea",
        "endorse any-user to associate compute-container-instances in compartment ske_compartment of tenancy ske with subnets in tenancy where ALL {request.principal.type='virtualnode',request.operation='CreateContainerInstance',request.principal.subnet=2.subnet.id}",
        "endorse any-user to associate compute-container-instances in compartment ske_compartment of tenancy ske with vnics in tenancy where ALL {request.principal.type='virtualnode',request.operation='CreateContainerInstance',request.principal.subnet=2.subnet.id}",
        "endorse any-user to associate compute-container-instances in compartment ske_compartment of tenancy ske with network-security-group in tenancy where ALL {request.principal.type='virtualnode',request.operation='CreateContainerInstance'}"
      ]
    }
  ]
}
