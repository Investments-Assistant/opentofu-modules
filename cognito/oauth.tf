resource "aws_cognito_user_pool_client" "alb" {
  name         = "${var.cluster_name}-alb"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  supported_identity_providers         = ["COGNITO"]
  prevent_user_existence_errors        = "ENABLED"

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = local.domain_prefix
  user_pool_id = aws_cognito_user_pool.main.id
}
