resource "aws_acm_certificate" "main" {
  count = local.enabled ? 1 : 0

  domain_name               = local.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  tags = merge(var.tags, {
    Name = local.domain_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "main" {
  count = local.enabled ? 1 : 0

  certificate_arn         = aws_acm_certificate.main[0].arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
