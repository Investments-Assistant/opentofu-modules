variable "role_name" {
  description = "IAM role name."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "role_name must be a valid IAM role name up to 64 characters."
  }
}

variable "oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:oidc-provider/.+", var.oidc_provider_arn))
    error_message = "oidc_provider_arn must be an IAM OIDC provider ARN."
  }
}

variable "oidc_provider_url" {
  description = "GitHub Actions OIDC provider URL. May include or omit https://."
  type        = string

  validation {
    condition     = trimspace(var.oidc_provider_url) != ""
    error_message = "oidc_provider_url must not be empty."
  }
}

variable "github_owner" {
  description = "GitHub organization or user that owns the repository."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+$", var.github_owner))
    error_message = "github_owner must be a GitHub organization or user name."
  }
}

variable "github_repository" {
  description = "GitHub repository allowed to assume this role."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "github_repository must be a GitHub repository name."
  }
}

variable "allowed_branches" {
  description = "Branches allowed to assume this role."
  type        = list(string)
  default     = ["main"]

  validation {
    condition     = length(var.allowed_branches) > 0 && alltrue([for branch in var.allowed_branches : trimspace(branch) != ""])
    error_message = "allowed_branches must contain at least one non-empty branch name."
  }
}

variable "extra_subjects" {
  description = "Additional GitHub OIDC sub claim patterns allowed to assume this role."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for subject in var.extra_subjects : trimspace(subject) != ""])
    error_message = "extra_subjects must not contain empty values."
  }
}

variable "policy_json" {
  description = "IAM policy JSON attached to the role as a managed policy."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy_json))
    error_message = "policy_json must be valid JSON."
  }
}

variable "tags" {
  description = "Additional tags for the role and policy."
  type        = map(string)
  default     = {}
}
