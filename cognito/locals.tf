locals {
  raw_domain_prefix = var.domain_prefix != null && trimspace(var.domain_prefix) != "" ? var.domain_prefix : "${var.cluster_name}-auth"
  domain_prefix     = substr(trim(replace(lower(local.raw_domain_prefix), "/[^a-z0-9-]/", "-"), "-"), 0, 63)
}
