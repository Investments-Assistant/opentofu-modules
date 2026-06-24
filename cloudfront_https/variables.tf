variable "name" {
  description = "Name prefix for the CloudFront distribution."
  type        = string
}

variable "origin_domain_name" {
  description = "ALB DNS name used as the CloudFront custom origin."
  type        = string
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
}

variable "wait_for_deployment" {
  description = "Whether OpenTofu waits until the CloudFront distribution is deployed."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the CloudFront distribution."
  type        = map(string)
  default     = {}
}
