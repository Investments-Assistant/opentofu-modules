output "user_pool_id" {
  description = "Cognito user pool ID."
  value       = aws_cognito_user_pool.main.id
}

output "user_pool_arn" {
  description = "Cognito user pool ARN."
  value       = aws_cognito_user_pool.main.arn
}

output "user_pool_client_id" {
  description = "ALB-compatible Cognito user pool app client ID."
  value       = aws_cognito_user_pool_client.alb.id
}

output "user_pool_client_secret" {
  description = "ALB-compatible Cognito user pool app client secret."
  value       = aws_cognito_user_pool_client.alb.client_secret
  sensitive   = true
}

output "user_pool_domain" {
  description = "Cognito hosted UI domain prefix used by ALB authentication."
  value       = aws_cognito_user_pool_domain.main.domain
}

output "groups" {
  description = "Created Cognito group names."
  value       = keys(aws_cognito_user_group.groups)
}
