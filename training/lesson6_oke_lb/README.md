# Lesson 06: Cluster with OCI Load Balancer

This lesson shows how the OKE module integrates with a Kubernetes `LoadBalancer` Service and OCI public networking. It uses the local `terraform-oci-fk-oke` module for the cluster, and composes FoggyKitchen networking modules for the surrounding VCN, reserved public IP, and optional load balancer NSG.

![](terraform-oci-fk-oke-lesson6.png)

## What This Lesson Shows

- An enhanced OKE cluster using the local `terraform-oci-fk-oke` module
- Reusable VCN composition through `terraform-oci-fk-vcn`
- Optional reserved public IP through `terraform-oci-fk-public-ip`
- Optional load balancer NSG through `terraform-oci-fk-nsg`
- Kubernetes manifest deployment for an OCI load-balanced NGINX Service

This lesson focuses on service exposure and OCI load balancer integration without keeping raw OCI networking resources in the lesson itself.

## Architecture Notes

This lesson uses:

- the local OKE module via `../..`
- `terraform-oci-fk-vcn` for the VCN, subnets, route tables, gateways, and security lists
- `terraform-oci-fk-public-ip` for the optional reserved load balancer frontend IP
- `terraform-oci-fk-nsg` for the optional OCI load balancer NSG

The OKE cluster is configured in [oke_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson6_oke_lb/oke_UPDATED.tf), the module-based network composition is defined in [network_NEW.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson6_oke_lb/network_NEW.tf), and the Kubernetes deployment flow is in [deploy_UPDATED.tf](/Users/mlinxfeld/codes/terraform-oci-fk-oke/training/lesson6_oke_lb/deploy_UPDATED.tf).

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-oke.git
cd terraform-oci-fk-oke/training/lesson6_oke_lb
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

Optional load balancer tuning:

```hcl
lb_shape                      = "flexible"
flex_lb_min_shape             = 10
flex_lb_max_shape             = 100
use_reserved_public_ip_for_lb = true
lb_nsg                        = true
lb_listener_port              = 80
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

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- an enhanced OKE cluster
- a managed node pool
- a VCN with public API and load balancer subnets plus a private node subnet
- an NGINX Deployment and Kubernetes `LoadBalancer` Service
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

Current load balancer defaults:

- `lb_shape = "flexible"`
- `flex_lb_min_shape = 10`
- `flex_lb_max_shape = 100`
- `use_reserved_public_ip_for_lb = true`
- `lb_nsg = true`
- `lb_listener_port = 80`

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

If you used the deployment path, allow extra time for the `local-exec` cleanup flow and OCI load balancer teardown.

## Contributing

This project is open source. Contributions are welcome through pull requests.

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
