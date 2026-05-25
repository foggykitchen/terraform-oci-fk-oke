# Lesson 03: Enhanced Cluster with OKE Add-Ons

This lesson extends the enhanced cluster example with OKE add-ons. It keeps the network layout explicit, reuses the same VCN composition pattern as lesson 2, and adds optional OCI IAM wiring for the Autonomous Database operator scenario.

![](terraform-oci-fk-oke-lesson3.png)

## What This Lesson Shows

- An enhanced OKE cluster using the local `terraform-oci-fk-oke` module
- A dedicated VCN created through `terraform-oci-fk-vcn`
- Inline OKE add-on configuration for:
  - `CertManager`
  - `OracleDatabaseOperator`
- Optional OCI IAM policy and dynamic group creation through `terraform-oci-fk-policy`
- Optional Autonomous Database deployment driven by `kubectl` and generated manifests

The base cluster path works without ADBS. The extra IAM and `kubectl` deployment steps are only used when `deploy_adbs = true`.

## Architecture Notes

This lesson now follows the same network composition model as lesson 2:

- public API endpoint subnet
- public load balancer subnet
- private node subnet
- VCN-native pod networking

The cluster itself is configured in [oke_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson3_oke_addons/oke_UPDATED.tf), and the VCN is defined in [networking.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson3_oke_addons/networking.tf).

When `deploy_adbs = true`, lesson 3 also creates:

- a dynamic group for OKE worker nodes
- a tenancy-level OCI policy for ADBS access

That IAM wiring is delegated to `github.com/mlinxfeld/terraform-oci-fk-policy` in [iam_NEW.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson3_oke_addons/iam_NEW.tf).

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/foggykitchen/terraform-oci-fk-oke/releases/latest/download/terraform-oci-fk-oke-lesson3.zip)
2. Review and accept the terms and conditions.
3. Select the region where you want to deploy the stack.
4. Create the stack and run **Plan**.
5. Review the plan and run **Apply** if it matches expectations.

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-oke.git
cd terraform-oci-fk-oke/training/lesson3_oke_addons
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

Optional ADBS path:

```hcl
deploy_adbs         = true
adbs_admin_password = "<strong_password>"
```

### Initialize Terraform

```bash
terraform init
```

Expected module sources:

- local `../..` for the OKE module
- `terraform-oci-fk-vcn` for network composition
- `terraform-oci-fk-policy` for optional IAM wiring

### Apply

```bash
terraform apply
```

With the default settings, this lesson creates:

- an enhanced OKE cluster
- three subnets for API, load balancer, and nodes
- OKE add-ons for `CertManager` and `OracleDatabaseOperator`

When `deploy_adbs = true`, Terraform additionally:

- creates OCI IAM resources for instance-principal access
- generates `adbs.yaml`
- creates the Kubernetes secret `adbs-admin-password`
- applies the Autonomous Database manifest

## Key Configuration

Current cluster settings:

- `cluster_type = "enhanced"`
- `k8s_version = "v1.35.2"`
- `node_linux_version = "8.10"`
- `oci_vcn_ip_native = true`
- `vcn_native = true`
- `use_existing_vcn = true`

The add-ons are defined inline in `oke_UPDATED.tf` rather than passed as an input variable. That keeps lesson 3 opinionated and makes the default add-on set visible directly in the example.

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

If `deploy_adbs = true`, allow extra time for the `local-exec` cleanup path and Kubernetes-side reconciliation.

## Contributing

This project is open source. Contributions are welcome through pull requests.

## License

Copyright (c) 2026 [FoggyKitchen.com](https://foggykitchen.com/)

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for details.
