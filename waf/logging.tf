resource "aws_cloudwatch_log_group" "waf" {
  name              = "aws-waf-logs-investments"
  retention_in_days = 30
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  log_destination_configs = [trimsuffix(aws_cloudwatch_log_group.waf.arn, ":*")]
  resource_arn            = aws_wafv2_web_acl.main.arn
}
