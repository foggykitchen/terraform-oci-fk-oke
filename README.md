# terraform-oci-fk-oke

This repository contains a reusable **Terraform / OpenTofu module** and progressive training examples for deploying **Oracle Container Engine for Kubernetes (OKE)** on **Oracle Cloud Infrastructure (OCI)**.

It is part of the [FoggyKitchen.com](https://foggykitchen.com) training ecosystem and is designed as a composable OKE layer that can be combined with networking, policy, storage, registry, and observability modules.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Purpose

The goal of this module is to provide a clear, reusable reference implementation for OKE:

- OKE cluster provisioning
- Basic and enhanced cluster modes
- Optional VCN creation or integration with an existing VCN
- Optional subnet creation for the cluster endpoint, node pool, and load balancer
- VCN-native pod networking for node pools
- Virtual node pool support
- OKE add-ons support
- Cluster autoscaler add-on and supporting node pools
- SSH key handling for node pool access

This is not a full landing zone module. Networking, cluster settings, and add-ons stay explicit so the module can be reused in different training or project scenarios.

---

## What the module does

Depending on the configuration, the module can create:

- OCI VCN
- Service gateway, NAT gateway, route tables, and internet gateway
- Cluster endpoint subnet
- Load balancer subnet
- Node pool subnet
- OKE cluster
- Regular node pools
- Virtual node pool
- Cluster add-ons
- Autoscaler node pool and autoscaler add-on

The module intentionally does not create:

- Application workloads
- Kubernetes manifests
- Persistent volume claims or workload-specific storage resources
- Bastion hosts
- External observability backends outside the module API

Those concerns belong in dedicated examples or separate modules.

---

## Repository Structure

```bash
terraform-oci-fk-oke/
├── README.md
├── LICENSE
├── provider.tf
├── datasources.tf
├── locals.tf
├── network.tf
├── oke_cluster.tf
├── oke_node_pools.tf
├── oke_virtual_node_pool.tf
├── oke_autoscaler_node_pools.tf
├── oke_addons.tf
├── outputs.tf
├── variables.tf
└── training/
    ├── README.md
    ├── lesson1_oke_basic_cluster/
    ├── lesson2_oke_enhanced_cluster/
    ├── lesson3_oke_addons/
    ├── lesson4_oke_virtual_nodes/
    ├── lesson5_oke_autoscaler/
    ├── lesson6_oke_lb/
    ├── lesson7_oke_block_volume_pvc/
    ├── lesson8_oke_fss_pvc/
    ├── lesson9_oke_ocir/
    └── lesson10_oke_logging/
```

Each lesson folder is runnable on its own and shows a narrower scenario built on top of the same OKE foundation.

---

## Example Usage

```hcl
module "oke" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-oke.git?ref=v0.1.0"

  compartment_ocid     = var.compartment_ocid
  tenancy_ocid         = var.tenancy_ocid
  oke_cluster_name     = "fk-oke-demo"
  cluster_type         = "enhanced"
  k8s_version          = "v1.35.2"

  use_existing_vcn     = false
  use_existing_nsg     = false
  vcn_native           = true
  vcn_cidr             = "10.0.0.0/16"
  nodepool_subnet_cidr = "10.0.1.0/24"
  lb_subnet_cidr       = "10.0.2.0/24"
  api_endpoint_subnet_cidr = "10.0.3.0/24"

  is_api_endpoint_subnet_public = false
  is_lb_subnet_public           = false
  is_nodepool_subnet_public     = false

  pool_name    = "fk-nodepool"
  node_shape   = "VM.Standard.E4.Flex"
  node_ocpus   = 1
  node_memory  = 4
  node_count   = 3

  oci_vcn_ip_native = true
  pods_cidr         = "10.1.0.0/16"
  services_cidr     = "10.2.0.0/16"

  autoscaler_enabled = false
}
```

---

## Inputs

| Variable | Type | Default | Description |
|---|---|---:|---|
| `compartment_ocid` | string | `""` | Compartment OCID where OKE resources are created |
| `tenancy_ocid` | string | `""` | Tenancy OCID used for availability domain lookup |
| `availability_domain` | string | `""` | Optional single availability domain filter |
| `use_existing_vcn` | bool | `true` | Reuse existing VCN and subnets instead of creating them |
| `use_existing_nsg` | bool | `true` | Reuse existing NSG IDs for node/pod networking |
| `vcn_cidr` | string | `10.0.0.0/16` | CIDR block used when the module creates a VCN |
| `vcn_id` | string | `""` | Existing VCN OCID |
| `nodepool_subnet_id` | string | `""` | Existing node pool subnet OCID |
| `nodepool_subnet_cidr` | string | `10.0.1.0/24` | Node pool subnet CIDR when created by the module |
| `lb_subnet_id` | string | `""` | Existing load balancer subnet OCID |
| `lb_subnet_cidr` | string | `10.0.2.0/24` | Load balancer subnet CIDR when created by the module |
| `api_endpoint_subnet_id` | string | `""` | Existing API endpoint subnet OCID |
| `api_endpoint_subnet_cidr` | string | `10.0.3.0/24` | Cluster endpoint subnet CIDR when created by the module |
| `api_endpoint_nsg_ids` | list(string) | `[]` | NSG IDs for the cluster endpoint when using an existing VCN |
| `pods_subnet_id` | string | `""` | Existing pod subnet OCID for VCN-native mode |
| `pods_nsg_ids` | list(string) | `[]` | NSG IDs for pod networking in VCN-native mode |
| `oke_cluster_name` | string | `FoggyKitchenOKECluster` | OKE cluster name |
| `vcn_native` | bool | `true` | Enable VCN-native cluster endpoint and subnet handling |
| `is_api_endpoint_subnet_public` | bool | `false` | Make the API endpoint subnet public |
| `is_lb_subnet_public` | bool | `false` | Make the load balancer subnet public |
| `is_nodepool_subnet_public` | bool | `false` | Make the node pool subnet public |
| `k8s_version` | string | `v1.35.2` | Kubernetes version |
| `pool_name` | string | `FoggyKitchenNodePool` | Node pool name prefix |
| `node_shape` | string | `VM.Standard.E4.Flex` | Shape used for node pools |
| `node_pool_image_id` | string | `""` | Custom image OCID when `node_pool_image_type = "custom"` |
| `node_pool_boot_volume_size_in_gbs` | number | `50` | Boot volume size for node pools |
| `node_ocpus` | number | `1` | OCPUs for flex shapes |
| `node_memory` | number | `4` | Memory in GB for flex shapes |
| `oci_vcn_ip_native` | bool | `false` | Enable OCI VCN-native pod networking |
| `max_pods_per_node` | number | `10` | Maximum pods per node in VCN-native mode |
| `pods_cidr` | string | `10.1.0.0/16` | Pods CIDR when not using OCI VCN-native mode |
| `services_cidr` | string | `10.2.0.0/16` | Kubernetes services CIDR |
| `pods_subnet_cidr` | string | `10.0.4.0/24` | Currently unused in the root module; kept for training scenarios |
| `virtual_node_pool` | bool | `false` | Create a virtual node pool instead of a regular node pool |
| `node_linux_version` | string | `8.10` | Oracle Linux version used to resolve platform/OKE image sources |
| `node_pool_count` | number | `1` | Number of regular node pools to create |
| `node_count` | number | `3` | Number of nodes per pool |
| `autoscaler_enabled` | bool | `false` | Create the autoscaler node pool and OKE add-on |
| `autoscaler_authtype_workload` | bool | `true` | Enable workload-based auth for the autoscaler add-on |
| `autoscaler_scale_down_delay_after_add` | string | `15m` | Autoscaler scale-down delay after scale-out |
| `autoscaler_scale_down_unneeded_time` | string | `10m` | Autoscaler scale-down timeout for unneeded nodes |
| `autoscaler_node_pool_count` | number | `1` | Number of autoscaler node pools to create |
| `autoscaler_min_number_of_nodes` | number | `1` | Autoscaler minimum node count |
| `autoscaler_max_number_of_nodes` | number | `10` | Autoscaler maximum node count |
| `node_pool_image_type` | string | `oke` | Image source type: `oke`, `platform`, or `custom` |
| `virtual_nodepool_pod_shape` | string | `Pod.Standard.E4.Flex` | Pod shape for virtual node pools |
| `virtual_nodepool_nsg_ids` | list(string) | `[]` | NSG IDs for virtual node pool networking |
| `cluster_type` | string | `enhanced` | Cluster type: `basic` or `enhanced` |
| `cluster_options_add_ons_is_kubernetes_dashboard_enabled` | bool | `true` | Enable Kubernetes dashboard add-on |
| `cluster_options_add_ons_is_tiller_enabled` | bool | `true` | Enable Tiller add-on |
| `cluster_options_admission_controller_options_is_pod_security_policy_enabled` | bool | `false` | Enable pod security policy admission |
| `node_pool_initial_node_labels_key` | string | `key` | Initial node label key |
| `node_pool_initial_node_labels_value` | string | `value` | Initial node label value |
| `cluster_kube_config_token_version` | string | `2.0.0` | Token version used for kubeconfig output |
| `ssh_public_key` | string | `""` | Optional SSH public key for node pools |
| `node_eviction_node_pool_settings` | bool | `false` | Enable node eviction settings on the node pool |
| `eviction_grace_duration` | string | `PT60M` | Eviction grace duration in ISO 8601 format |
| `is_force_delete_after_grace_duration` | bool | `true` | Force node deletion after the grace period |
| `fk_oke_addon_map` | map(object) | `{}` | Custom OKE add-on definitions |

---

## Outputs

| Output | Description |
|---|---|
| `cluster` | Cluster ID, Kubernetes version, and name |
| `node_pool` | Node pool IDs, versions, names, and node private IPs |
| `chosen_node_shape_and_image` | Resolved node image source name and image ID |
| `KubeConfig` | Raw kubeconfig content |
| `oke_cluster_addons` | Current cluster add-ons data |
| `oke_addon_options` | Available add-on options for the selected Kubernetes version |

---

## Design Principles

- The root module stays reusable instead of turning into a full platform wrapper
- Networking and cluster access patterns stay explicit
- Training examples build on one another, but each lesson remains runnable on its own
- Outputs are treated as first-class values, because downstream lessons and examples need them

---

## Notes

- `pods_subnet_cidr` is currently unused in the root module and appears to be reserved for training scenarios.
- `region` is present in `variables.tf`, but the provider config is expected to supply region in the usual Terraform way.
- `cluster_type` is validated and accepts only `basic` or `enhanced`.

---

## Related Resources

- [Training examples](training)
- [FoggyKitchen OCI VCN Module](https://github.com/foggykitchen/terraform-oci-fk-vcn)
- [FoggyKitchen OCI NSG Module](https://github.com/foggykitchen/terraform-oci-fk-nsg)
- [FoggyKitchen OCI Public IP Module](https://github.com/foggykitchen/terraform-oci-fk-public-ip)
- [FoggyKitchen OCI Policy Module](https://github.com/foggykitchen/terraform-oci-fk-policy)
- [FoggyKitchen OCI Block Volume Module](https://github.com/foggykitchen/terraform-oci-fk-blockvolume)
- [FoggyKitchen OCI File Storage Module](https://github.com/foggykitchen/terraform-oci-fk-filestorage)
- [FoggyKitchen OCI OCIR Module](https://github.com/foggykitchen/terraform-oci-fk-ocir)
- [FoggyKitchen OCI Logging Module](https://github.com/foggykitchen/terraform-oci-fk-logging)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
