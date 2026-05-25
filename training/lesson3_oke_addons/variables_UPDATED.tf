variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}

variable "deploy_adbs" {
  description = "Choose if you want to deploy Autonomous Database Serverless with Database Operator."
  type        = bool
  default     = false
}
variable "adbs_admin_password" {
  description = "Autonomous Database Serverless ADMIN User Password"
  type        = string
  default     = "BEstrO0ng_#11"
}

variable "adbs_database_display_name" {
  description = "Autonomous Database Serverless Display Name"
  type        = string
  default     = "FoggyKitchenADBS"
}

variable "adbs_database_dbname" {
  description = "Autonomous Database Serverless DBName"
  type        = string
  default     = "FKDB1"
}
