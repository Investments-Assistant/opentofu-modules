locals {
  public_subnets  = [for i, az in var.azs : cidrsubnet("10.0.0.0/16", 8, i)]
  private_subnets = [for i, az in var.azs : cidrsubnet("10.0.0.0/16", 8, i + 10)]
}
