locals {
  enabled          = var.domain_name != null && trimspace(var.domain_name) != ""
  domain_name      = local.enabled ? trimspace(var.domain_name) : null
  provided_zone_id = var.route53_zone_id != null && trimspace(var.route53_zone_id) != "" ? trimspace(var.route53_zone_id) : null
  lookup_zone      = local.enabled && local.provided_zone_id == null
  route53_zone_id  = local.enabled ? (local.provided_zone_id != null ? local.provided_zone_id : try(data.aws_route53_zone.selected[0].zone_id, null)) : null
}
