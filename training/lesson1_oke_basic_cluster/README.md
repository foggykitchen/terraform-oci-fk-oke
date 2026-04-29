# Lesson 01: Basic OKE Cluster

This is Lesson 1 from the FoggyKitchen [OCI Kubernetes Course](https://foggykitchen.com/courses/oci-kubernetes-course/). It deploys a minimal Oracle Container Engine for Kubernetes (OKE) cluster using the reusable FoggyKitchen OKE module.

It is intentionally small. The goal is to establish the baseline architecture for the rest of the training track and to stop at `tofu plan`.

---

## Architecture Overview

![](terraform-oci-fk-oke-lesson1-architecture.png)

This deployment plans to create:

- A new OCI VCN
- A cluster API endpoint subnet
- A load balancer subnet
- A node pool subnet with worker nodes
- NAT Gateway and Internet Gateway for outbound access
- Security lists for the cluster networking
- A basic OKE cluster

With `use_existing_vcn = false`, the module creates the networking resources itself.
With `cluster_type = "basic"`, the cluster is created in basic mode rather than enhanced mode.

---

## OCI Console View

The following screenshot shows the created OKE resources in OCI Console:

![](terraform-oci-fk-oke-lesson1-oci-console.png)

---

## Module Composition

The lesson uses the root module through the `fk-oke` module block:

```hcl
module "fk-oke" {
  source = "../.."

  tenancy_ocid                  = var.tenancy_ocid
  compartment_ocid              = var.compartment_ocid
  cluster_type                  = "basic"
  k8s_version                   = "v1.31.1"
  node_linux_version            = "8.10"
  node_shape                    = "VM.Standard.A1.Flex"
  node_ocpus                    = 1
  node_memory                   = 4
  use_existing_vcn              = false
  is_api_endpoint_subnet_public = true
  is_lb_subnet_public           = true
  is_nodepool_subnet_public     = true
}
```

The important settings are:

- `use_existing_vcn = false` makes the module create the network stack.
- `cluster_type = "basic"` keeps the lesson on the basic OKE path.
- `is_api_endpoint_subnet_public = true`, `is_lb_subnet_public = true`, and `is_nodepool_subnet_public = true` keep the example reachable in a simple public-network setup.

---

## Deployment Steps

Use OpenTofu from the lesson directory:

```bash
tofu init
tofu plan
tofu apply
```

If the plan looks correct, it should show the OKE cluster, node pool, and supporting network resources.

This lesson is intentionally limited to planning so that you can inspect the architecture before any infrastructure is created.

---

## Cleanup

If you apply the example later and want to remove everything created by it:

```bash
tofu destroy
```

---

## Summary

This example demonstrates:

- How to deploy a basic OKE cluster using the reusable FoggyKitchen module
- How the module creates the core network resources when no existing VCN is provided
- The baseline OKE setup used for comparison with the enhanced cluster in Lesson 02

---

## Learn More

Visit [FoggyKitchen.com](https://foggykitchen.com/) for OCI, multicloud, and Terraform learning resources, including the full [OCI Kubernetes Course](https://foggykitchen.com/courses/oci-kubernetes-course/).

---

## License

Licensed under the Universal Permissive License (UPL), Version 1.0.
See [LICENSE](../../LICENSE) for more details.
