module "fk_vcn" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-vcn.git?ref=v0.1.0"

  compartment_ocid = var.compartment_ocid
  name             = "FoggyKitchenVCN"
  vcn_cidr_blocks  = [var.network_cidrs["VCN-CIDR"]]
  dns_label        = "fkvcn"

  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true

  route_tables = {
    private = {
      display_name = "FoggyKitchenVCNPrivateRouteTable"
      route_rules = [
        {
          description        = "Traffic to the internet"
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "nat_gateway"
        },
        {
          description        = "Traffic to OCI services"
          destination        = "all-services"
          destination_type   = "SERVICE_CIDR_BLOCK"
          network_entity_key = "service_gateway"
        }
      ]
    }
    public = {
      display_name = "FoggyKitchenVCNPublicRouteTable"
      route_rules = [
        {
          description        = "Traffic to/from internet"
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "internet_gateway"
        }
      ]
    }
  }

  security_lists = {
    nodes = {
      display_name = "FoggyKitchenOKENodesSecurityList"
      ingress_rules = [
        {
          description = "Allow pods on one worker node to communicate with pods on other worker nodes"
          protocol    = local.all_protocols
          source      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
        },
        {
          description = "Allow pods on one worker node to communicate with FSS on port 111/TCP"
          protocol    = local.tcp_protocol_number
          source      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.fss_port_1)
            max = tonumber(local.fss_port_1)
          }
        },
        {
          description = "Allow pods on one worker node to communicate with FSS on ports 2048-2050/TCP"
          protocol    = local.tcp_protocol_number
          source      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.fss_port_2)
            max = tonumber(local.fss_port_4)
          }
        },
        {
          description = "Allow pods on one worker node to communicate with FSS on port 111/UDP"
          protocol    = local.udp_protocol_number
          source      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
          udp_options = {
            min = tonumber(local.fss_port_1)
            max = tonumber(local.fss_port_1)
          }
        },
        {
          description = "Allow pods on one worker node to communicate with FSS on ports 2048-2050/UDP"
          protocol    = local.udp_protocol_number
          source      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
          udp_options = {
            min = tonumber(local.fss_port_2)
            max = tonumber(local.fss_port_4)
          }
        },
        {
          description = "Inbound SSH traffic to worker nodes"
          protocol    = local.tcp_protocol_number
          source      = var.network_cidrs["VCN-CIDR"]
          source_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.ssh_port_number)
            max = tonumber(local.ssh_port_number)
          }
        },
        {
          description = "TCP access from Kubernetes Control Plane"
          protocol    = local.tcp_protocol_number
          source      = var.network_cidrs["ENDPOINT-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
        },
        {
          description = "Path discovery"
          protocol    = local.icmp_protocol_number
          source      = var.network_cidrs["ENDPOINT-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
          icmp_options = {
            type = 3
            code = 4
          }
        }
      ]
      egress_rules = [
        {
          description      = "Allow pods on one worker node to communicate with pods on other worker nodes"
          protocol         = local.all_protocols
          destination      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
        },
        {
          description      = "Worker Nodes access to Internet"
          protocol         = local.all_protocols
          destination      = var.network_cidrs["ALL-CIDR"]
          destination_type = "CIDR_BLOCK"
        },
        {
          description      = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
          protocol         = local.tcp_protocol_number
          destination      = "all-services"
          destination_type = "SERVICE_CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.https_port_number)
            max = tonumber(local.https_port_number)
          }
        },
        {
          description      = "Allow pods on one worker node to communicate with FSS on port 111/TCP"
          protocol         = local.tcp_protocol_number
          destination      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.fss_port_1)
            max = tonumber(local.fss_port_1)
          }
        },
        {
          description      = "Allow pods on one worker node to communicate with FSS on ports 2048-2050/TCP"
          protocol         = local.tcp_protocol_number
          destination      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.fss_port_2)
            max = tonumber(local.fss_port_4)
          }
        },
        {
          description      = "Allow pods on one worker node to communicate with FSS on port 111/UDP"
          protocol         = local.udp_protocol_number
          destination      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
          udp_options = {
            min = tonumber(local.fss_port_1)
            max = tonumber(local.fss_port_1)
          }
        },
        {
          description      = "Allow pods on one worker node to communicate with FSS on ports 2048-2050/UDP"
          protocol         = local.udp_protocol_number
          destination      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
          udp_options = {
            min = tonumber(local.fss_port_2)
            max = tonumber(local.fss_port_4)
          }
        },
        {
          description      = "ICMP Access from Kubernetes Control Plane"
          protocol         = local.icmp_protocol_number
          destination      = var.network_cidrs["ALL-CIDR"]
          destination_type = "CIDR_BLOCK"
          icmp_options = {
            type = 3
            code = 4
          }
        },
        {
          description      = "Access to Kubernetes API Endpoint"
          protocol         = local.tcp_protocol_number
          destination      = var.network_cidrs["ENDPOINT-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.oke_api_endpoint_port_number)
            max = tonumber(local.oke_api_endpoint_port_number)
          }
        },
        {
          description      = "Kubernetes worker to control plane communication"
          protocol         = local.tcp_protocol_number
          destination      = var.network_cidrs["ENDPOINT-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.oke_nodes_to_control_plane_port_number)
            max = tonumber(local.oke_nodes_to_control_plane_port_number)
          }
        },
        {
          description      = "Path discovery"
          protocol         = local.icmp_protocol_number
          destination      = var.network_cidrs["ENDPOINT-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
          icmp_options = {
            type = 3
            code = 4
          }
        }
      ]
    }
    lb = {
      display_name = "FoggyKitchenOKELBSecurityList"
      ingress_rules = [
        {
          description = "External access to Load Balancer in K8S"
          protocol    = local.tcp_protocol_number
          source      = var.network_cidrs["ALL-CIDR"]
          source_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.lb_listener_port)
            max = tonumber(local.lb_listener_port)
          }
        }
      ]
      egress_rules = [
        {
          description      = "Allow traffic to Kubernetes Worker Nodes"
          protocol         = local.tcp_protocol_number
          destination      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.oke_nodes_min_port)
            max = tonumber(local.oke_nodes_max_port)
          }
        }
      ]
    }
    api_endpoint = {
      display_name = "FoggyKitchenOKEAPIEndpointSecurityList"
      ingress_rules = [
        {
          description = "External access to Kubernetes API endpoint"
          protocol    = local.tcp_protocol_number
          source      = var.network_cidrs["ALL-CIDR"]
          source_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.oke_api_endpoint_port_number)
            max = tonumber(local.oke_api_endpoint_port_number)
          }
        },
        {
          description = "Kubernetes worker to Kubernetes API endpoint communication"
          protocol    = local.tcp_protocol_number
          source      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.oke_api_endpoint_port_number)
            max = tonumber(local.oke_api_endpoint_port_number)
          }
        },
        {
          description = "Kubernetes worker to control plane communication"
          protocol    = local.tcp_protocol_number
          source      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.oke_nodes_to_control_plane_port_number)
            max = tonumber(local.oke_nodes_to_control_plane_port_number)
          }
        },
        {
          description = "Path discovery"
          protocol    = local.icmp_protocol_number
          source      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          source_type = "CIDR_BLOCK"
          icmp_options = {
            type = 3
            code = 4
          }
        }
      ]
      egress_rules = [
        {
          description      = "Allow Kubernetes Control Plane to communicate with OKE"
          protocol         = local.tcp_protocol_number
          destination      = "all-services"
          destination_type = "SERVICE_CIDR_BLOCK"
          tcp_options = {
            min = tonumber(local.https_port_number)
            max = tonumber(local.https_port_number)
          }
        },
        {
          description      = "All traffic to worker nodes"
          protocol         = local.tcp_protocol_number
          destination      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
        },
        {
          description      = "Path discovery"
          protocol         = local.icmp_protocol_number
          destination      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
          destination_type = "CIDR_BLOCK"
          icmp_options = {
            type = 3
            code = 4
          }
        }
      ]
    }
  }

  subnets = {
    api_endpoint = {
      cidr_block                    = var.network_cidrs["ENDPOINT-SUBNET-REGIONAL-CIDR"]
      display_name                  = "FoggyKitchenOKEAPIEndpointSubnet"
      dns_label                     = "endpsub"
      route_table_key               = "public"
      security_list_keys            = ["api_endpoint"]
      include_default_security_list = false
      prohibit_public_ip_on_vnic    = false
    }
    nodes = {
      cidr_block                    = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
      display_name                  = "FoggyKitchenOKENodesPodsSubnet"
      dns_label                     = "nodessub"
      route_table_key               = "private"
      security_list_keys            = ["nodes"]
      include_default_security_list = false
      prohibit_public_ip_on_vnic    = true
    }
    lb = {
      cidr_block                    = var.network_cidrs["LB-SUBNET-REGIONAL-CIDR"]
      display_name                  = "FoggyKitchenOKELBSubnet"
      dns_label                     = "lbsub"
      route_table_key               = "public"
      security_list_keys            = ["lb"]
      include_default_security_list = false
      prohibit_public_ip_on_vnic    = false
    }
  }
}

module "fk_public_ip_lb" {
  count  = var.use_reserved_public_ip_for_lb ? 1 : 0
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-public-ip.git?ref=v1.0.0"

  name                         = "fk-lb-public-ip"
  compartment_ocid             = var.compartment_ocid
  ignore_private_ip_id_changes = true
}

module "fk_nsg_lb" {
  count  = var.lb_nsg ? 1 : 0
  source = "github.com/foggykitchen/terraform-oci-fk-nsg"

  name             = "fk-lb-nsg"
  compartment_ocid = var.compartment_ocid
  vcn_id           = module.fk_vcn.vcn_id

  security_rules = [
    {
      name        = "allow-lb-ingress"
      direction   = "INGRESS"
      protocol    = local.tcp_protocol_number
      source      = var.network_cidrs["ALL-CIDR"]
      source_type = "CIDR_BLOCK"
      description = "External access to Load Balancer in K8S"
      tcp_options = {
        destination_port_range = {
          min = tonumber(local.lb_listener_port)
          max = tonumber(local.lb_listener_port)
        }
      }
    },
    {
      name             = "allow-lb-egress-to-workers"
      direction        = "EGRESS"
      protocol         = local.tcp_protocol_number
      destination      = var.network_cidrs["NODES-PODS-SUBNET-REGIONAL-CIDR"]
      destination_type = "CIDR_BLOCK"
      description      = "Allow traffic to Kubernetes Worker Nodes"
      tcp_options = {
        destination_port_range = {
          min = tonumber(local.oke_nodes_min_port)
          max = tonumber(local.oke_nodes_max_port)
        }
      }
    }
  ]
}
