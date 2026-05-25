# Lesson 09: Cluster with OCIR Image Pull

This lesson covers private image pull from OCI Registry (OCIR) into Kubernetes workloads running on OKE. It uses the local `terraform-oci-fk-oke` module for the cluster, FoggyKitchen networking modules for the surrounding VCN and load balancer path, and `terraform-oci-fk-ocir` for OCI Registry repository provisioning.

![](terraform-oci-fk-oke-lesson9.png)

## What This Lesson Shows

- An enhanced OKE cluster using the local `terraform-oci-fk-oke` module
- Reusable VCN composition through `terraform-oci-fk-vcn`
- Optional reserved public IP through `terraform-oci-fk-public-ip`
- Optional load balancer NSG through `terraform-oci-fk-nsg`
- OCI Registry repository provisioning through `terraform-oci-fk-ocir`
- Docker build, push, image pull secret creation, and workload deployment flow for private images

This lesson focuses on image distribution and private pull mechanics while keeping OCI infrastructure concerns on reusable FoggyKitchen modules instead of raw resources in the lesson.

## Architecture Notes

This lesson uses:

- the local OKE module via `../..`
- `terraform-oci-fk-vcn` for the VCN, subnets, route tables, gateways, and security lists
- `terraform-oci-fk-public-ip` for the optional reserved load balancer frontend IP
- `terraform-oci-fk-nsg` for the optional OCI load balancer NSG
- `terraform-oci-fk-ocir` for the OCI Registry repository and canonical image path outputs

The OKE cluster is configured in [oke.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson9_oke_ocir/oke.tf), module-based infrastructure composition is defined in [network.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson9_oke_ocir/network.tf), and the OCIR plus Kubernetes deployment flow is in [deploy_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson9_oke_ocir/deploy_UPDATED.tf).

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-oke.git
cd terraform-oci-fk-oke/training/lesson9_oke_ocir
```

### Create `terraform.tfvars`

Start from the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Minimum required values:

```hcl
tenancy_ocid       = "ocid1.tenancy.oc1..<your_tenancy_ocid>"
user_ocid          = "ocid1.user.oc1..<your_user_ocid>"
compartment_ocid   = "ocid1.compartment.oc1..<your_compartment_ocid>"
region             = "<oci_region>"
fingerprint        = "<fingerprint>"
private_key_path   = "<private_key_path>"
ocir_user_name     = "<oci_username>"
ocir_user_password = "<oci_auth_token>"
```

For Oracle Identity Cloud Service accounts, prefix the username with `oracleidentitycloudservice/`.

Optional image pull and load balancer tuning:

```hcl
ocir_repo_name                = "fknginx"
ocir_user_email               = "your.email@example.com"
number_of_nginx_replicas      = 10
lb_shape                      = "flexible"
use_reserved_public_ip_for_lb = true
lb_nsg                        = true
```

### Local Tooling Prerequisites

This lesson uses `local-exec` steps for image packaging and deployment flow. The machine running Terraform or OpenTofu needs:

- `docker`
- `oci`
- `kubectl`

### Initialize Terraform

```bash
terraform init
```

Expected module sources:

- local `../..` for the OKE module
- `terraform-oci-fk-vcn` for network composition
- `terraform-oci-fk-public-ip` for the optional reserved public IP
- `terraform-oci-fk-nsg` for the optional load balancer NSG
- `terraform-oci-fk-ocir` for the OCI Registry repository

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- an enhanced OKE cluster
- a managed node pool
- a VCN with public API and load balancer subnets plus a private node subnet
- an OCI Registry repository
- a demo Docker image built locally and pushed to OCIR
- a Kubernetes private registry secret, Service, and NGINX Deployment
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

Current registry and image defaults:

- `ocir_repo_name = "fknginx"`
- repository path created by the lesson: `fknginx/fknginx`
- image pushed by the lesson: `${image_prefix}/fknginx:latest`
- `number_of_nginx_replicas = 10`

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

If you used the deployment path, allow extra time for the `local-exec` cleanup flow, OCI load balancer teardown, and image-related local cleanup steps.

## Contributing

This project is open source. Contributions are welcome through pull requests.

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
