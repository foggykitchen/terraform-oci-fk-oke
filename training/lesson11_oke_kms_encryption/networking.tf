module "fk-vcn" {
  providers = { oci = oci.targetregion }
  source    = "git::https://github.com/foggykitchen/terraform-oci-fk-vcn.git?ref=v0.1.0"

  compartment_ocid = var.compartment_ocid
  name             = "foggykitchen-vcn"
  vcn_cidr_blocks  = ["10.20.0.0/16"]

  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true

  route_tables = {
    public = {
      route_rules = [
        {
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "internet_gateway"
        }
      ]
    }
    private = {
      route_rules = [
        {
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "nat_gateway"
        },
        {
          destination        = "all-services"
          destination_type   = "SERVICE_CIDR_BLOCK"
          network_entity_key = "service_gateway"
        }
      ]
    }
  }

  security_lists = {
    oke_api = {
      egress_rules = [
        {
          protocol    = "6"
          destination = "10.20.30.0/24"
          tcp_options = {
            min = 6443
            max = 6443
          }
        },
        {
          protocol    = "6"
          destination = "10.20.30.0/24"
          tcp_options = {
            min = 12250
            max = 12250
          }
        },
        {
          protocol    = "6"
          destination = "0.0.0.0/0"
          tcp_options = {
            min = 443
            max = 443
          }
        },
        {
          protocol    = "1"
          destination = "10.20.30.0/24"
          icmp_options = {
            type = 3
            code = 4
          }
        }
      ]
      ingress_rules = [
        {
          protocol = "6"
          source   = "10.20.30.0/24"
          tcp_options = {
            min = 6443
            max = 6443
          }
        },
        {
          protocol = "6"
          source   = "10.20.30.0/24"
          tcp_options = {
            min = 12250
            max = 12250
          }
        },
        {
          protocol = "6"
          source   = "0.0.0.0/0"
          tcp_options = {
            min = 6443
            max = 6443
          }
        },
        {
          protocol = "1"
          source   = "10.20.30.0/24"
          icmp_options = {
            type = 3
            code = 4
          }
        }
      ]
    }

    oke_nodes = {
      egress_rules = [
        {
          protocol    = "all"
          destination = "10.20.30.0/24"
        },
        {
          protocol    = "1"
          destination = "0.0.0.0/0"
          icmp_options = {
            type = 3
            code = 4
          }
        },
        {
          protocol    = "6"
          destination = "0.0.0.0/0"
          tcp_options = {
            min = 443
            max = 443
          }
        },
        {
          protocol    = "6"
          destination = "10.20.10.0/28"
          tcp_options = {
            min = 6443
            max = 6443
          }
        },
        {
          protocol    = "6"
          destination = "10.20.10.0/28"
          tcp_options = {
            min = 12250
            max = 12250
          }
        }
      ]
      ingress_rules = [
        {
          protocol = "all"
          source   = "10.20.30.0/24"
        },
        {
          protocol = "6"
          source   = "10.20.10.0/28"
        },
        {
          protocol = "1"
          source   = "0.0.0.0/0"
          icmp_options = {
            type = 3
            code = 4
          }
        },
        {
          protocol = "6"
          source   = "10.20.20.0/24"
        }
      ]
    }
  }

  subnets = {
    api_endpoint = {
      display_name               = "foggykitchen-oke-api-endpoint-subnet"
      cidr_block                 = "10.20.10.0/28"
      route_table_key            = "public"
      prohibit_public_ip_on_vnic = false
      security_list_keys         = ["oke_api"]
    }
    lb = {
      display_name               = "foggykitchen-oke-lb-subnet"
      cidr_block                 = "10.20.20.0/24"
      route_table_key            = "public"
      prohibit_public_ip_on_vnic = false
    }
    nodes = {
      display_name               = "foggykitchen-oke-nodes-subnet"
      cidr_block                 = "10.20.30.0/24"
      route_table_key            = "private"
      prohibit_internet_ingress  = true
      prohibit_public_ip_on_vnic = true
      security_list_keys         = ["oke_nodes"]
    }
  }
}
