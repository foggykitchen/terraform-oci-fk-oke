# Lesson 07: Cluster with OCI Block Volume PVC

This lesson covers OCI Block Volume-backed persistent storage for Kubernetes workloads. It uses the local `terraform-oci-fk-oke` module for the cluster, FoggyKitchen networking modules for the surrounding VCN and load balancer path, and `terraform-oci-fk-blockvolume` for the optional pre-created volume consumed by the PVC flow.

![](terraform-oci-fk-oke-lesson7.png)

## What This Lesson Shows

- An enhanced OKE cluster using the local `terraform-oci-fk-oke` module
- Reusable VCN composition through `terraform-oci-fk-vcn`
- Optional reserved public IP through `terraform-oci-fk-public-ip`
- Optional load balancer NSG through `terraform-oci-fk-nsg`
- Optional pre-created OCI Block Volume through `terraform-oci-fk-blockvolume`
- Kubernetes StorageClass, PVC, and NGINX deployment flow for persistent storage

This lesson focuses on PVC-backed application storage while keeping OCI infrastructure concerns on reusable FoggyKitchen modules instead of raw resources in the lesson.

## Architecture Notes

This lesson uses:

- the local OKE module via `../..`
- `terraform-oci-fk-vcn` for the VCN, subnets, route tables, gateways, and security lists
- `terraform-oci-fk-public-ip` for the optional reserved load balancer frontend IP
- `terraform-oci-fk-nsg` for the optional OCI load balancer NSG
- `terraform-oci-fk-blockvolume` for the optional pre-created OCI block volume

The OKE cluster is configured in [oke_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson7_oke_block_volume_pvc/oke_UPDATED.tf), module-based infrastructure composition is defined in [network.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson7_oke_block_volume_pvc/network.tf) and [block_volume_NEW.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson7_oke_block_volume_pvc/block_volume_NEW.tf), and the Kubernetes deployment flow is in [deploy_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson7_oke_block_volume_pvc/deploy_UPDATED.tf).

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-oke.git
cd terraform-oci-fk-oke/training/lesson7_oke_block_volume_pvc
```

### Create `terraform.tfvars`

Start from the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Minimum required values:

```hcl
tenancy_ocid     = "ocid1.tenancy.oc1..<your_tenancy_ocid>"
user_ocid        = "ocid1.user.oc1..<your_user_ocid>"
compartment_ocid = "ocid1.compartment.oc1..<your_compartment_ocid>"
region           = "<oci_region>"
fingerprint      = "<fingerprint>"
private_key_path = "<private_key_path>"
```

Optional storage and load balancer tuning:

```hcl
pvc_from_existing_block_volume = true
block_volume_name              = "fkblockvolume"
block_volume_size              = 50
fs_type                        = "ext4"
vpus_per_gb                    = 0
lb_shape                       = "flexible"
use_reserved_public_ip_for_lb  = true
lb_nsg                         = true
```

### Initialize Terraform

```bash
terraform init
```

Expected module sources:

- local `../..` for the OKE module
- `terraform-oci-fk-vcn` for network composition
- `terraform-oci-fk-public-ip` for the optional reserved public IP
- `terraform-oci-fk-nsg` for the optional load balancer NSG
- `terraform-oci-fk-blockvolume` for the optional pre-created block volume

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- an enhanced OKE cluster
- a managed node pool
- a VCN with public API and load balancer subnets plus a private node subnet
- a Kubernetes StorageClass, PVC, Service, and NGINX Deployment
- an OCI load balancer provisioned through Kubernetes Service integration

When `pvc_from_existing_block_volume = true`, Terraform additionally creates an OCI block volume first and injects its ID into the PVC manifest.

When `use_reserved_public_ip_for_lb = true`, Terraform additionally creates a reserved public IP for the load balancer frontend.

When `lb_nsg = true`, Terraform additionally creates a dedicated OCI NSG for the load balancer and injects its OCID into the Service annotation.

## Key Configuration

Current cluster settings:

- `cluster_type = "enhanced"`
- `k8s_version = "v1.35.2"`
- `node_linux_version = "8.10"`
- `oci_vcn_ip_native = true`
- `use_existing_vcn = true`

Current storage defaults:

- `pvc_from_existing_block_volume = true`
- `block_volume_size = 50`
- `fs_type = "ext4"`
- `vpus_per_gb = 0`

Current load balancer defaults:

- `lb_shape = "flexible"`
- `flex_lb_min_shape = 10`
- `flex_lb_max_shape = 100`
- `use_reserved_public_ip_for_lb = true`
- `lb_nsg = true`

## Outputs

This lesson exports:

- `KubeConfig`
- `Cluster`
- `NodePool`

## Destroy

To remove all resources created by this lesson:

```bash
terraform destroy
```

If you used the deployment path, allow extra time for the `local-exec` cleanup flow, OCI load balancer teardown, and PVC-related reconciliation.

## Contributing

This project is open source. Contributions are welcome through pull requests.

## License

Copyright (c) 2026 [FoggyKitchen.com](https://foggykitchen.com/)

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for details.
