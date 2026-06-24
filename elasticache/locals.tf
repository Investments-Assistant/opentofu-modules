locals {
  auth_token = var.auth_token == null || trimspace(var.auth_token) == "" ? null : var.auth_token
}
