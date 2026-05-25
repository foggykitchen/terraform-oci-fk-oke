locals {
  availability_domains          = var.availability_domain == "" ? data.oci_identity_availability_domains.ADs.availability_domains : data.oci_identity_availability_domains.AD.availability_domains
  node_pool_image_ids           = data.oci_containerengine_node_pool_option.fk_oke_node_pool_option.sources
  k8s_version_only              = replace(var.k8s_version, "v", "")
  k8s_version_regex             = replace(local.k8s_version_only, ".", "\\.")
  oke_specific_image_regex      = var.node_pool_image_type == "oke" ? (length(regexall("GPU", var.node_shape)) > 0 ? "Oracle-Linux-${var.node_linux_version}-Gen[0-9]-GPU-20[0-9]*.*-OKE-${local.k8s_version_regex}" : length(regexall("A1", var.node_shape)) > 0 ? "Oracle-Linux-${var.node_linux_version}-aarch64-20[0-9]*.*-OKE-${local.k8s_version_regex}" : "Oracle-Linux-${var.node_linux_version}-20[0-9]*.*-OKE-${local.k8s_version_regex}") : null
  oci_platform_image_regex      = var.node_pool_image_type == "platform" ? (length(regexall("GPU", var.node_shape)) > 0 ? "Oracle-Linux-${var.node_linux_version}-Gen[0-9]-GPU-\\d{4}\\.\\d{2}\\.\\d{2}-[0-9]*" : length(regexall("A1", var.node_shape)) > 0 ? "Oracle-Linux-${var.node_linux_version}-aarch64-\\d{4}\\.\\d{2}\\.\\d{2}-[0-9]*" : "Oracle-Linux-${var.node_linux_version}-\\d{4}\\.\\d{2}\\.\\d{2}-[0-9]*") : null
  oke_specific_image_candidates = local.oke_specific_image_regex != null ? [for source in local.node_pool_image_ids : source.image_id if length(regexall(local.oke_specific_image_regex, source.source_name)) > 0] : []
  oke_specific_image_names      = local.oke_specific_image_regex != null ? [for source in local.node_pool_image_ids : source.source_name if length(regexall(local.oke_specific_image_regex, source.source_name)) > 0] : []
  oci_platform_image_candidates = local.oci_platform_image_regex != null ? [for source in local.node_pool_image_ids : source.image_id if length(regexall(local.oci_platform_image_regex, source.source_name)) > 0] : []
  oci_platform_image_names      = local.oci_platform_image_regex != null ? [for source in local.node_pool_image_ids : source.source_name if length(regexall(local.oci_platform_image_regex, source.source_name)) > 0] : []
  selected_image_id             = var.node_pool_image_type == "oke" ? try(element(local.oke_specific_image_candidates, 0), element(local.oci_platform_image_candidates, 0), null) : var.node_pool_image_type == "platform" ? try(element(local.oci_platform_image_candidates, 0), null) : null
  selected_image_name           = var.node_pool_image_type == "oke" ? try(element(local.oke_specific_image_names, 0), element(local.oci_platform_image_names, 0), null) : var.node_pool_image_type == "platform" ? try(element(local.oci_platform_image_names, 0), null) : null
  fk_oke_addon_map              = var.cluster_type == "enhanced" ? var.fk_oke_addon_map : {}
}
