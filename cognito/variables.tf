variable "cluster_name" {
  description = "Cluster/application name used to name Cognito resources."
  type        = string
}

variable "domain_prefix" {
  description = "Cognito hosted UI domain prefix. Must be globally unique in the AWS region."
  type        = string
  default     = null
}

variable "callback_urls" {
  description = "OAuth callback URLs, for example https://app.example.com/oauth2/idpresponse."
  type        = list(string)
}

variable "logout_urls" {
  description = "Allowed OAuth logout URLs."
  type        = list(string)
  default     = []
}

variable "groups" {
  description = "Cognito groups to create with description and precedence."
  type = map(object({
    description = string
    precedence  = number
  }))
  default = {
    viewer = {
      description = "Can chat with the assistant about news only."
      precedence  = 30
    }
    investor = {
      description = "Can use market data, news, simulations, and reports, but not portfolio tools."
      precedence  = 20
    }
    admin = {
      description = "Can use every assistant service and administrative trading controls."
      precedence  = 10
    }
  }
}

variable "tags" {
  description = "Additional tags for Cognito resources."
  type        = map(string)
  default     = {}
}
