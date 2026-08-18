variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}

variable "availability_domain" {
  default = ""
}

variable "kubernetes_version" {
  default = "v1.35.2"
}

variable "node_linux_version" {
  default = "8.10"
}

variable "node_pool_size" {
  default = 3
}
