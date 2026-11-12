# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "local" {
}
mock_provider "null" {
}
mock_provider "oci" {
  mock_data "oci_containerengine_addon_options" {
    defaults = { "addon_options" = [{ "addon_group" = "mock-value", "addon_schema_version" = "mock-value", "defined_tags" = {}, "description" = "mock-value", "freeform_tags" = {}, "is_essential" = false, "name" = "compatibility", "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "versions" = [{ "configurations" = [], "description" = "mock-value", "kubernetes_version_filters" = [], "status" = "mock-value", "version_number" = "mock-value" }] }], "id" = "MOCK_OCID_OPTIONS" }
  }
  mock_data "oci_containerengine_addons" {
    defaults = { "addons" = [{ "addon_error" = [{ "code" = "mock-value", "message" = "mock-value", "status" = "mock-value" }], "addon_name" = "mock-value", "cluster_id" = "MOCK_OCID_MOCK", "configurations" = [{ "key" = "FRA", "value" = "mock-value" }], "current_installed_version" = "mock-value", "override_existing" = false, "remove_addon_resources_on_delete" = false, "state" = "AVAILABLE", "time_created" = "mock-value", "version" = "mock-value" }], "id" = "MOCK_OCID_ADDONS" }
  }
  mock_data "oci_containerengine_cluster_kube_config" {
    defaults = { "content" = "apiVersion: v1\nclusters: []\nusers: []\ncontexts: []\n", "id" = "MOCK_OCID_CONFIG" }
  }
  mock_data "oci_containerengine_cluster_option" {
    defaults = { "cluster_pod_network_options" = [{ "cni_type" = "mock-value" }], "id" = "MOCK_OCID_OPTION", "kubernetes_versions" = ["mock-value"] }
  }
  mock_data "oci_containerengine_node_pool_option" {
    defaults = { "id" = "MOCK_OCID_OPTION", "images" = ["mock-value"], "kubernetes_versions" = ["mock-value"], "shapes" = ["mock-value"], "sources" = [{ "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-2025.04.30-0-OKE-1.31.1", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-aarch64-2025.04.30-0-OKE-1.31.1", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-Gen2-GPU-2025.04.30-0-OKE-1.31.1", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-2025.04.30-0-OKE-1.35.2", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-aarch64-2025.04.30-0-OKE-1.35.2", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-Gen2-GPU-2025.04.30-0-OKE-1.35.2", "source_type" = "IMAGE" }] }
  }
  mock_data "oci_core_services" {
    defaults = { "id" = "MOCK_OCID_SERVICES", "services" = [{ "cidr_block" = "all-fra-services-in-oracle-services-network", "description" = "mock-value", "id" = "mock-service", "name" = "All FRA Services In Oracle Services Network" }] }
  }
  mock_data "oci_identity_availability_domains" {
    defaults = { "availability_domains" = [{ "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-1" }, { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-2" }, { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-3" }], "id" = "MOCK_OCID_DOMAINS" }
  }
  mock_resource "oci_containerengine_addon" {
    defaults = { "addon_error" = [{ "code" = "mock-value", "message" = "mock-value", "status" = "mock-value" }], "current_installed_version" = "mock-value", "id" = "MOCK_OCID_ADDON", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_containerengine_cluster" {
    defaults = { "available_kubernetes_upgrades" = ["mock-value"], "endpoints" = [{ "ipv6endpoint" = "mock-value", "kubernetes" = "mock-value", "private_endpoint" = "mock-value", "public_endpoint" = "mock-value", "vcn_hostname_endpoint" = "mock-value" }], "id" = "MOCK_OCID_CLUSTER", "lifecycle_details" = "mock-value", "metadata" = [{ "created_by_user_id" = "MOCK_OCID_MOCK", "created_by_work_request_id" = "MOCK_OCID_MOCK", "deleted_by_user_id" = "MOCK_OCID_MOCK", "deleted_by_work_request_id" = "MOCK_OCID_MOCK", "time_created" = "mock-value", "time_credential_expiration" = "mock-value", "time_deleted" = "mock-value", "time_updated" = "mock-value", "updated_by_user_id" = "MOCK_OCID_MOCK", "updated_by_work_request_id" = "MOCK_OCID_MOCK" }], "open_id_connect_discovery_endpoint" = "mock-value", "open_id_connect_discovery_key" = "mock-value", "state" = "AVAILABLE", "system_tags" = {} }
  }
  mock_resource "oci_containerengine_node_pool" {
    defaults = { "id" = "MOCK_OCID_POOL", "lifecycle_details" = "mock-value", "node_source" = [{ "image_id" = "MOCK_OCID_MOCK", "source_name" = "mock-value", "source_type" = "mock-value" }], "nodes" = [{ "availability_domain" = "MOCK:EU-FRANKFURT-1-AD-1", "defined_tags" = {}, "error" = [{ "code" = "mock-value", "message" = "mock-value", "status" = "mock-value" }], "fault_domain" = "mock-value", "freeform_tags" = {}, "id" = "MOCK_OCID_MOCK", "kubernetes_version" = "mock-value", "lifecycle_details" = "mock-value", "name" = "compatibility", "node_pool_id" = "MOCK_OCID_MOCK", "private_ip" = "10.0.0.10", "public_ip" = "mock-value", "state" = "AVAILABLE", "subnet_id" = "MOCK_OCID_SUBNET", "system_tags" = {} }], "state" = "AVAILABLE", "system_tags" = {} }
  }
  mock_resource "oci_containerengine_virtual_node_pool" {
    defaults = { "id" = "MOCK_OCID_POOL", "kubernetes_version" = "mock-value", "lifecycle_details" = "mock-value", "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "time_updated" = "mock-value" }
  }
  mock_resource "oci_core_dhcp_options" {
    defaults = { "id" = "MOCK_OCID_OPTIONS", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_internet_gateway" {
    defaults = { "id" = "MOCK_OCID_GATEWAY", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_nat_gateway" {
    defaults = { "id" = "MOCK_OCID_GATEWAY", "nat_ip" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_network_security_group" {
    defaults = { "id" = "MOCK_OCID_GROUP", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_network_security_group_security_rule" {
    defaults = { "id" = "MOCK_OCID_RULE", "is_valid" = false, "time_created" = "mock-value" }
  }
  mock_resource "oci_core_public_ip" {
    defaults = { "assigned_entity_id" = "MOCK_OCID_MOCK", "assigned_entity_type" = "mock-value", "availability_domain" = "MOCK:EU-FRANKFURT-1-AD-1", "id" = "MOCK_OCID_IP", "ip_address" = "10.0.0.10", "scope" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_route_table" {
    defaults = { "id" = "MOCK_OCID_TABLE", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_security_list" {
    defaults = { "id" = "MOCK_OCID_LIST", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_service_gateway" {
    defaults = { "block_traffic" = false, "id" = "MOCK_OCID_GATEWAY", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_subnet" {
    defaults = { "id" = "MOCK_OCID_SUBNET", "ipv6virtual_router_ip" = "mock-value", "state" = "AVAILABLE", "subnet_domain_name" = "mock-value", "time_created" = "mock-value", "virtual_router_ip" = "mock-value", "virtual_router_mac" = "mock-value" }
  }
  mock_resource "oci_core_vcn" {
    defaults = { "byoipv6cidr_blocks" = ["mock-value"], "default_dhcp_options_id" = "MOCK_OCID_MOCK", "default_route_table_id" = "MOCK_OCID_MOCK", "default_security_list_id" = "MOCK_OCID_MOCK", "id" = "MOCK_OCID_VCN", "ipv6cidr_blocks" = ["mock-value"], "state" = "AVAILABLE", "time_created" = "mock-value", "vcn_domain_name" = "mock-value" }
  }
  mock_resource "oci_core_volume" {
    defaults = { "auto_tuned_vpus_per_gb" = "mock-value", "id" = "MOCK_OCID_VOLUME", "is_hydrated" = false, "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "volume_group_id" = "MOCK_OCID_MOCK" }
  }
  mock_resource "oci_core_volume_attachment" {
    defaults = { "availability_domain" = "MOCK:EU-FRANKFURT-1-AD-1", "chap_secret" = "mock-value", "chap_username" = "mock-value", "id" = "MOCK_OCID_ATTACHMENT", "ipv4" = "mock-value", "ipv6" = "mock-value", "iqn" = "mock-value", "is_encryption_in_transit_enabled" = false, "is_multipath" = false, "is_volume_created_during_launch" = false, "iscsi_login_state" = "mock-value", "multipath_devices" = [{ "ipv4" = "mock-value", "iqn" = "mock-value", "port" = 1 }], "port" = 1, "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
}
mock_provider "tls" {
}
mock_provider "oci" {
  alias = "targetregion"
  mock_data "oci_containerengine_addon_options" {
    defaults = { "addon_options" = [{ "addon_group" = "mock-value", "addon_schema_version" = "mock-value", "defined_tags" = {}, "description" = "mock-value", "freeform_tags" = {}, "is_essential" = false, "name" = "compatibility", "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "versions" = [{ "configurations" = [], "description" = "mock-value", "kubernetes_version_filters" = [], "status" = "mock-value", "version_number" = "mock-value" }] }], "id" = "MOCK_OCID_OPTIONS" }
  }
  mock_data "oci_containerengine_addons" {
    defaults = { "addons" = [{ "addon_error" = [{ "code" = "mock-value", "message" = "mock-value", "status" = "mock-value" }], "addon_name" = "mock-value", "cluster_id" = "MOCK_OCID_MOCK", "configurations" = [{ "key" = "FRA", "value" = "mock-value" }], "current_installed_version" = "mock-value", "override_existing" = false, "remove_addon_resources_on_delete" = false, "state" = "AVAILABLE", "time_created" = "mock-value", "version" = "mock-value" }], "id" = "MOCK_OCID_ADDONS" }
  }
  mock_data "oci_containerengine_cluster_kube_config" {
    defaults = { "content" = "apiVersion: v1\nclusters: []\nusers: []\ncontexts: []\n", "id" = "MOCK_OCID_CONFIG" }
  }
  mock_data "oci_containerengine_cluster_option" {
    defaults = { "cluster_pod_network_options" = [{ "cni_type" = "mock-value" }], "id" = "MOCK_OCID_OPTION", "kubernetes_versions" = ["mock-value"] }
  }
  mock_data "oci_containerengine_node_pool_option" {
    defaults = { "id" = "MOCK_OCID_OPTION", "images" = ["mock-value"], "kubernetes_versions" = ["mock-value"], "shapes" = ["mock-value"], "sources" = [{ "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-2025.04.30-0-OKE-1.31.1", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-aarch64-2025.04.30-0-OKE-1.31.1", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-Gen2-GPU-2025.04.30-0-OKE-1.31.1", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-2025.04.30-0-OKE-1.35.2", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-aarch64-2025.04.30-0-OKE-1.35.2", "source_type" = "IMAGE" }, { "image_id" = "MOCK_OCID_IMAGE", "source_name" = "Oracle-Linux-8.10-Gen2-GPU-2025.04.30-0-OKE-1.35.2", "source_type" = "IMAGE" }] }
  }
  mock_data "oci_core_services" {
    defaults = { "id" = "MOCK_OCID_SERVICES", "services" = [{ "cidr_block" = "all-fra-services-in-oracle-services-network", "description" = "mock-value", "id" = "mock-service", "name" = "All FRA Services In Oracle Services Network" }] }
  }
  mock_data "oci_identity_availability_domains" {
    defaults = { "availability_domains" = [{ "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-1" }, { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-2" }, { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-3" }], "id" = "MOCK_OCID_DOMAINS" }
  }
  mock_resource "oci_containerengine_addon" {
    defaults = { "addon_error" = [{ "code" = "mock-value", "message" = "mock-value", "status" = "mock-value" }], "current_installed_version" = "mock-value", "id" = "MOCK_OCID_ADDON", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_containerengine_cluster" {
    defaults = { "available_kubernetes_upgrades" = ["mock-value"], "endpoints" = [{ "ipv6endpoint" = "mock-value", "kubernetes" = "mock-value", "private_endpoint" = "mock-value", "public_endpoint" = "mock-value", "vcn_hostname_endpoint" = "mock-value" }], "id" = "MOCK_OCID_CLUSTER", "lifecycle_details" = "mock-value", "metadata" = [{ "created_by_user_id" = "MOCK_OCID_MOCK", "created_by_work_request_id" = "MOCK_OCID_MOCK", "deleted_by_user_id" = "MOCK_OCID_MOCK", "deleted_by_work_request_id" = "MOCK_OCID_MOCK", "time_created" = "mock-value", "time_credential_expiration" = "mock-value", "time_deleted" = "mock-value", "time_updated" = "mock-value", "updated_by_user_id" = "MOCK_OCID_MOCK", "updated_by_work_request_id" = "MOCK_OCID_MOCK" }], "open_id_connect_discovery_endpoint" = "mock-value", "open_id_connect_discovery_key" = "mock-value", "state" = "AVAILABLE", "system_tags" = {} }
  }
  mock_resource "oci_containerengine_node_pool" {
    defaults = { "id" = "MOCK_OCID_POOL", "lifecycle_details" = "mock-value", "node_source" = [{ "image_id" = "MOCK_OCID_MOCK", "source_name" = "mock-value", "source_type" = "mock-value" }], "nodes" = [{ "availability_domain" = "MOCK:EU-FRANKFURT-1-AD-1", "defined_tags" = {}, "error" = [{ "code" = "mock-value", "message" = "mock-value", "status" = "mock-value" }], "fault_domain" = "mock-value", "freeform_tags" = {}, "id" = "MOCK_OCID_MOCK", "kubernetes_version" = "mock-value", "lifecycle_details" = "mock-value", "name" = "compatibility", "node_pool_id" = "MOCK_OCID_MOCK", "private_ip" = "10.0.0.10", "public_ip" = "mock-value", "state" = "AVAILABLE", "subnet_id" = "MOCK_OCID_SUBNET", "system_tags" = {} }], "state" = "AVAILABLE", "system_tags" = {} }
  }
  mock_resource "oci_containerengine_virtual_node_pool" {
    defaults = { "id" = "MOCK_OCID_POOL", "kubernetes_version" = "mock-value", "lifecycle_details" = "mock-value", "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "time_updated" = "mock-value" }
  }
  mock_resource "oci_core_dhcp_options" {
    defaults = { "id" = "MOCK_OCID_OPTIONS", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_internet_gateway" {
    defaults = { "id" = "MOCK_OCID_GATEWAY", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_nat_gateway" {
    defaults = { "id" = "MOCK_OCID_GATEWAY", "nat_ip" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_network_security_group" {
    defaults = { "id" = "MOCK_OCID_GROUP", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_network_security_group_security_rule" {
    defaults = { "id" = "MOCK_OCID_RULE", "is_valid" = false, "time_created" = "mock-value" }
  }
  mock_resource "oci_core_public_ip" {
    defaults = { "assigned_entity_id" = "MOCK_OCID_MOCK", "assigned_entity_type" = "mock-value", "availability_domain" = "MOCK:EU-FRANKFURT-1-AD-1", "id" = "MOCK_OCID_IP", "ip_address" = "10.0.0.10", "scope" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_route_table" {
    defaults = { "id" = "MOCK_OCID_TABLE", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_security_list" {
    defaults = { "id" = "MOCK_OCID_LIST", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_service_gateway" {
    defaults = { "block_traffic" = false, "id" = "MOCK_OCID_GATEWAY", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_subnet" {
    defaults = { "id" = "MOCK_OCID_SUBNET", "ipv6virtual_router_ip" = "mock-value", "state" = "AVAILABLE", "subnet_domain_name" = "mock-value", "time_created" = "mock-value", "virtual_router_ip" = "mock-value", "virtual_router_mac" = "mock-value" }
  }
  mock_resource "oci_core_vcn" {
    defaults = { "byoipv6cidr_blocks" = ["mock-value"], "default_dhcp_options_id" = "MOCK_OCID_MOCK", "default_route_table_id" = "MOCK_OCID_MOCK", "default_security_list_id" = "MOCK_OCID_MOCK", "id" = "MOCK_OCID_VCN", "ipv6cidr_blocks" = ["mock-value"], "state" = "AVAILABLE", "time_created" = "mock-value", "vcn_domain_name" = "mock-value" }
  }
  mock_resource "oci_core_volume" {
    defaults = { "auto_tuned_vpus_per_gb" = "mock-value", "id" = "MOCK_OCID_VOLUME", "is_hydrated" = false, "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "volume_group_id" = "MOCK_OCID_MOCK" }
  }
  mock_resource "oci_core_volume_attachment" {
    defaults = { "availability_domain" = "MOCK:EU-FRANKFURT-1-AD-1", "chap_secret" = "mock-value", "chap_username" = "mock-value", "id" = "MOCK_OCID_ATTACHMENT", "ipv4" = "mock-value", "ipv6" = "mock-value", "iqn" = "mock-value", "is_encryption_in_transit_enabled" = false, "is_multipath" = false, "is_volume_created_during_launch" = false, "iscsi_login_state" = "mock-value", "multipath_devices" = [{ "ipv4" = "mock-value", "iqn" = "mock-value", "port" = 1 }], "port" = 1, "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
}
variables {
  tenancy_ocid     = "MOCK_OCID_TENANCY"
  user_ocid        = "MOCK_OCID_MOCK"
  private_key_path = "/unused-by-mock"
  compartment_ocid = "MOCK_OCID_COMPARTMENT"
  region           = "eu-frankfurt-1"
  fingerprint      = "compatibility"
}

run "oci9_plan" {
  command   = plan
  providers = { local = local, null = null, oci = oci, tls = tls, oci.targetregion = oci.targetregion }
}
