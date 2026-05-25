# Lesson 05: Enhanced Cluster with Autoscaler

This lesson adds the OKE cluster autoscaler to the enhanced cluster path. It uses the local `terraform-oci-fk-oke` module for the cluster itself and reuses the shared `terraform-oci-fk-policy` module from FoggyKitchen GitHub for the required OCI IAM wiring.

![](terraform-oci-fk-oke-lesson5.png)

## What This Lesson Shows

- An enhanced OKE cluster using the local `terraform-oci-fk-oke` module
- The OKE Cluster Autoscaler add-on enabled through module inputs
- Autoscaler node pool bounds and scale-down settings
- OCI IAM authorization for both supported autoscaler auth modes:
  - workload identity principal
  - instance principal

This lesson keeps the autoscaler policy statements explicit in the lesson while delegating OCI IAM resource lifecycle to the shared `terraform-oci-fk-policy` module.

## Architecture Notes

This lesson uses:

- the local OKE module via `../..`
- the shared IAM module via `github.com/foggykitchen/terraform-oci-fk-policy`
- module-managed networking inside the OKE module
- an enhanced OKE cluster with autoscaler enabled

The cluster configuration lives in [oke_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson5_oke_autoscaler/oke_UPDATED.tf), and the IAM composition is defined in [iam_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson5_oke_autoscaler/iam_UPDATED.tf).

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-oke.git
cd terraform-oci-fk-oke/training/lesson5_oke_autoscaler
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

Optional autoscaler tuning:

```hcl
autoscaler_authtype_workload = true
node_pool_size               = 3
min_number_of_nodes          = 3
max_number_of_nodes          = 5
```

### Initialize Terraform

```bash
terraform init
```

Expected module sources:

- local `../..` for the OKE module
- `terraform-oci-fk-policy` for autoscaler IAM resources

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- an enhanced OKE cluster
- a managed node pool
- the OKE Cluster Autoscaler add-on
- module-managed VCN and subnet resources inside the OKE module
- OCI IAM resources for the selected autoscaler auth mode

When `autoscaler_authtype_workload = true`, Terraform creates workload-identity-based IAM policy statements tied to the cluster ID.

When `autoscaler_authtype_workload = false`, Terraform instead creates:

- a dynamic group for the autoscaler instance-principal path
- a tenancy-level OCI policy bound to that dynamic group

## Key Configuration

Current cluster settings:

- `cluster_type = "enhanced"`
- `k8s_version = "v1.35.2"`
- `node_linux_version = "8.10"`
- `oci_vcn_ip_native = true`
- `autoscaler_enabled = true`
- `use_existing_vcn = false`

Autoscaler settings in this lesson:

- `autoscaler_min_number_of_nodes = 3`
- `autoscaler_max_number_of_nodes = 5`
- `autoscaler_scale_down_delay_after_add = "5m"`
- `autoscaler_scale_down_unneeded_time = "5m"`

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

## Contributing

This project is open source. Contributions are welcome through pull requests.

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
