data "aws_route53_zone" "selected" {
  count = local.lookup_zone ? 1 : 0

  name         = var.route53_zone_name
  private_zone = false
}
