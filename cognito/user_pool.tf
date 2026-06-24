resource "aws_cognito_user_pool" "main" {
  name = "${var.cluster_name}-users"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  password_policy {
    minimum_length                   = 14
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 5
      max_length = 2048
    }
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-users"
  })
}

resource "aws_cognito_user_group" "groups" {
  for_each = var.groups

  user_pool_id = aws_cognito_user_pool.main.id
  name         = each.key
  description  = each.value.description
  precedence   = each.value.precedence
}
