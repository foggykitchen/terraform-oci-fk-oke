# Lesson 08: Cluster with OCI File Storage PVC

This lesson covers OCI File Storage Service-backed persistent storage for Kubernetes workloads. It uses the local `terraform-oci-fk-oke` module for the cluster, FoggyKitchen networking modules for the surrounding VCN and load balancer path, and `terraform-oci-fk-filestorage` for the shared FSS layer consumed by the PVC flow.

![](terraform-oci-fk-oke-lesson8.png)

## What This Lesson Shows

- An enhanced OKE cluster using the local `terraform-oci-fk-oke` module
- Reusable VCN composition through `terraform-oci-fk-vcn`
- Optional reserved public IP through `terraform-oci-fk-public-ip`
- Optional load balancer NSG through `terraform-oci-fk-nsg`
- Shared OCI File Storage provisioned through `terraform-oci-fk-filestorage`
- Kubernetes PV, PVC, Service, and NGINX deployment flow for shared persistent storage

This lesson focuses on ReadWriteMany shared storage while keeping OCI infrastructure concerns on reusable FoggyKitchen modules instead of raw resources in the lesson.

## Architecture Notes

This lesson uses:

- the local OKE module via `../..`
- `terraform-oci-fk-vcn` for the VCN, subnets, route tables, gateways, and security lists
- `terraform-oci-fk-public-ip` for the optional reserved load balancer frontend IP
- `terraform-oci-fk-nsg` for the optional OCI load balancer NSG
- `terraform-oci-fk-filestorage` for the mount target, file system, and export

The OKE cluster is configured in [oke_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson8_oke_fss_pvc/oke_UPDATED.tf), module-based infrastructure composition is defined in [network_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson8_oke_fss_pvc/network_UPDATED.tf) and [fss_NEW.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson8_oke_fss_pvc/fss_NEW.tf), and the Kubernetes deployment flow is in [deploy_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson8_oke_fss_pvc/deploy_UPDATED.tf).

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-oke.git
cd terraform-oci-fk-oke/training/lesson8_oke_fss_pvc
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

Optional file storage and load balancer tuning:

```hcl
mount_target_ip_address   = "10.20.30.5"
file_storage_export_path  = "/ocifss"
lb_shape                  = "flexible"
use_reserved_public_ip_for_lb = true
lb_nsg                    = true
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
- `terraform-oci-fk-filestorage` for the shared OCI File Storage layer

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- an enhanced OKE cluster
- a managed node pool
- a VCN with public API and load balancer subnets plus a private node subnet
- an OCI File Storage mount target, file system, and export
- a Kubernetes PV, PVC, Service, and NGINX Deployment
- an OCI load balancer provisioned through Kubernetes Service integration

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

- `mount_target_ip_address = "10.20.30.5"`
- `file_storage_export_path = "/ocifss"`
- `pv_name = "oke-fsspv"`
- `pvc_name = "oke-fsspvc"`
- `pv_size = 100`
- `pvc_size = 100`

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

If you used the deployment path, allow extra time for the `local-exec` cleanup flow, OCI load balancer teardown, and PV or PVC-related reconciliation.

## Contributing

This project is open source. Contributions are welcome through pull requests.

## License

Copyright (c) 2026 [FoggyKitchen.com](https://foggykitchen.com/)

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for details.
