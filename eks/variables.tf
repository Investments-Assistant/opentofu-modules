variable "cluster_name" { type = string }
variable "k8s_version" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "node_instance_type" { type = string }
variable "node_min_size" { type = number }
variable "node_max_size" { type = number }
variable "node_desired_size" { type = number }
variable "enable_llm_node_group" { type = bool }
variable "llm_node_instance_type" { type = string }
variable "llm_node_min_size" { type = number }
variable "llm_node_max_size" { type = number }
variable "llm_node_desired_size" { type = number }
variable "aws_region" {
  description = "Deprecated compatibility input. Helm-managed add-ons receive the region from the deployment command."
  type        = string
  default     = null
}
variable "authentication_mode" {
  description = "EKS authentication mode. Use API_AND_CONFIG_MAP to enable access entries while keeping aws-auth compatibility."
  type        = string
  default     = "API_AND_CONFIG_MAP"

  validation {
    condition     = contains(["CONFIG_MAP", "API_AND_CONFIG_MAP", "API"], var.authentication_mode)
    error_message = "authentication_mode must be CONFIG_MAP, API_AND_CONFIG_MAP, or API."
  }
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Whether EKS grants cluster-admin access to the principal that created the cluster."
  type        = bool
  default     = true
}
