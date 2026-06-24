# WAF must be regional (not CloudFront) to attach to an ALB.
resource "aws_wafv2_ip_set" "allowed" {
  name               = "investments-allowed-ips"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.allowed_ip_cidrs

  lifecycle { create_before_destroy = true }
}

resource "aws_wafv2_web_acl" "main" {
  name  = "investments-allowlist"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "AllowMyIP"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allowed.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowMyIP"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AllowForwardedClientIP"
    priority = 2

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allowed.arn

        ip_set_forwarded_ip_config {
          fallback_behavior = "NO_MATCH"
          header_name       = "X-Forwarded-For"
          position          = "FIRST"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowForwardedClientIP"
      sampled_requests_enabled   = true
    }
  }

  # Allow health check from within the cluster (ALB targets).
  rule {
    name     = "AllowHealthCheck"
    priority = 3

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          uri_path {}
        }
        positional_constraint = "STARTS_WITH"
        search_string         = "/api/health"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AllowHealthCheck"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "investments-waf"
    sampled_requests_enabled   = true
  }
}
