# FoggyKitchen OCI Container Engine for Kubernetes with Terraform

This directory contains the progressive examples used in the FoggyKitchen OKE training track.

Each lesson builds on the previous one, moving from a basic cluster through enhanced clusters, add-ons, virtual node pools, autoscaling, load balancing, and persistent storage.

The 2026 codebase prefers reusable `terraform-oci-fk-oke` module composition over large one-off examples wherever that makes the architecture clearer and more maintainable.

---

## Example Overview

| Lesson | Title | Key Topics |
|---:|---|---|
| 01 | [**Basic OKE Cluster**](lesson1_oke_basic_cluster/) | Minimal OKE cluster and baseline networking |
| 02 | [**Enhanced OKE Cluster**](lesson2_oke_enhanced_cluster/) | Enhanced cluster mode and core OKE features |
| 03 | [**Enhanced Cluster with OKE Add-Ons**](lesson3_oke_addons/) | Cluster add-ons and add-on configuration |
| 04 | [**Enhanced Cluster with Virtual Node Pool**](lesson4_oke_virtual_nodes/) | Virtual node pool provisioning |
| 05 | [**Enhanced Cluster with Autoscaler**](lesson5_oke_autoscaler/) | Cluster autoscaler add-on and node pool sizing |
| 06 | [**Cluster with OCI Load Balancer**](lesson6_oke_lb/) | Load balancer service and subnet wiring |
| 07 | [**Cluster with OCI Block Volume PVC**](lesson7_oke_block_volume_pvc/) | Block Volume-based persistent storage |
| 08 | [**Cluster with OCI File Storage PVC**](lesson8_oke_fss_pvc/) | File Storage Service-based persistent storage |
| 09 | [**Cluster with OCIR Image Pull**](lesson9_oke_ocir/) | OCI Registry integration and private image pull path |
| 10 | [**Basic Cluster with OCI Logging**](lesson10_oke_logging/) | Logging, observability, and workload traces |

---

## How To Use

Each lesson directory includes:

- Terraform configuration files
- Kubernetes manifests or generated manifests
- Architecture or deployment screenshots
- A step-by-step `README.md`

To run a lesson:

```bash
cd training/lesson1_oke_basic_cluster
terraform init
terraform apply
```

The lessons can be applied independently, but the recommended approach is sequential:

01 -> 02 -> 03 -> 04 -> 05 -> 06 -> 07 -> 08 -> 09 -> 10

---

## Design Principles

- One lesson equals one architectural goal
- Dependencies stay explicit
- The module under test is always the local OCI OKE module
- Training examples should be runnable on their own
- Documentation should mirror the actual module contract

The training examples intentionally avoid:

- Full landing zones
- Hidden dependencies between lessons
- Opinionated enterprise wrappers

---

## Related Resources

- [FoggyKitchen OKE Module](../README.md)
- [FoggyKitchen.com](https://foggykitchen.com/)

---

## License

Licensed under the Universal Permissive License (UPL), Version 1.0.
See [LICENSE](../LICENSE) for details.
