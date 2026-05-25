# Lesson 04: Enhanced Cluster with Virtual Node Pool

This lesson focuses on OKE virtual node pools. It uses the local `terraform-oci-fk-oke` module for the cluster path, keeps the lesson-owned configuration explicit, and reuses the shared `terraform-oci-fk-policy` module from FoggyKitchen GitHub for the required IAM policy.

![](terraform-oci-fk-oke-lesson4.png)

## What This Lesson Shows

- An enhanced OKE cluster using the local `terraform-oci-fk-oke` module
- A virtual node pool instead of a managed worker node pool
- A tenancy-level IAM policy created through `terraform-oci-fk-policy`
- Optional Kubernetes deployment steps driven by generated manifests and `kubectl`

This lesson intentionally keeps the virtual node IAM policy statements explicit in the calling layer while delegating OCI IAM resource lifecycle to the shared policy module.

## Architecture Notes

This lesson uses:

- the local OKE module via `../..`
- the shared IAM module via `github.com/foggykitchen/terraform-oci-fk-policy`
- module-managed networking inside the OKE module
- an enhanced OKE cluster with a virtual node pool

The cluster is configured in [oke_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson4_oke_virtual_nodes/oke_UPDATED.tf), and the IAM policy composition is defined in [iam_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson4_oke_virtual_nodes/iam_UPDATED.tf).

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/foggykitchen/terraform-oci-fk-oke/releases/latest/download/terraform-oci-fk-oke-lesson4.zip)
2. Review and accept the terms and conditions.
3. Select the region where you want to deploy the stack.
4. Create the stack and run **Plan**.
5. Review the plan and run **Apply** if it matches expectations.

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-oke.git
cd terraform-oci-fk-oke/training/lesson4_oke_virtual_nodes
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

### Initialize Terraform

```bash
terraform init
```

Expected module sources:

- local `../..` for the OKE module
- `terraform-oci-fk-policy` for the tenancy-level virtual node IAM policy

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- an enhanced OKE cluster
- a virtual node pool
- module-managed VCN and subnet resources inside the OKE module
- the required tenancy-level IAM policy for virtual node networking

If the optional deployment path is enabled, Terraform additionally:

- generates `nginx.yaml`
- creates kubeconfig through the OCI CLI
- applies the Kubernetes manifest with `kubectl`

## Key Configuration

Current cluster settings:

- `cluster_type = "enhanced"`
- `k8s_version = "v1.35.2"`
- `node_linux_version = "8.10"`
- `oci_vcn_ip_native = true`
- `virtual_node_pool = true`
- `use_existing_vcn = false`

The IAM policy statements remain explicit in `iam_UPDATED.tf`, but the OCI IAM resource itself is created through the shared `terraform-oci-fk-policy` module.

## Outputs

This lesson exports:

- `KubeConfig`
- `Cluster`
- `NodePool`
- `ClusterAddOns`

## Destroy

To remove all resources created by this lesson:

```bash
terraform destroy
```

If you used the deployment path, allow extra time for the `local-exec` cleanup flow and Kubernetes-side reconciliation.

## Contributing

This project is open source. Contributions are welcome through pull requests.

## License

Copyright (c) 2026 [FoggyKitchen.com](https://foggykitchen.com/)

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for details.
