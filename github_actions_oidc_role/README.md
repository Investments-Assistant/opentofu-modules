# GitHub Actions OIDC Role Module

Creates an IAM role that a GitHub Actions workflow can assume through the
GitHub OIDC provider.

## Resources

- `aws_iam_role.this`: IAM role trusted by GitHub Actions OIDC.
- `aws_iam_policy.this`: managed policy built from `policy_json`.
- `aws_iam_role_policy_attachment.this`: attaches the managed policy to the
  role.

The trust policy is scoped by:

- OIDC audience `sts.amazonaws.com`.
- GitHub `sub` claims for the configured repository branches.
- Optional additional `sub` claim patterns from `extra_subjects`.

## Example

```hcl
module "github_actions_build_role" {
  source = "git::ssh://git@github.com/Investments-Assistant/opentofu-modules.git//github_actions_oidc_role?ref=0.0.1"

  role_name         = "investments-assistant-github-actions-build-role"
  oidc_provider_arn = aws_iam_openid_connect_provider.github_actions.arn
  oidc_provider_url = "token.actions.githubusercontent.com"
  github_owner      = "Investments-Assistant"
  github_repository = "investments-assistant-k8s"
  allowed_branches  = ["main"]
  policy_json       = data.aws_iam_policy_document.github_actions_build.json
  tags              = var.tags
}
```

## Inputs

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `role_name` | `string` | Yes | IAM role name. |
| `oidc_provider_arn` | `string` | Yes | GitHub Actions OIDC provider ARN. |
| `oidc_provider_url` | `string` | Yes | GitHub Actions OIDC provider URL, with or without `https://`. |
| `github_owner` | `string` | Yes | GitHub organization or user that owns the repository. |
| `github_repository` | `string` | Yes | GitHub repository allowed to assume this role. |
| `policy_json` | `string` | Yes | IAM policy JSON attached to the role as a managed policy. |
| `allowed_branches` | `list(string)` | No | Branches allowed to assume this role. Defaults to `["main"]`. |
| `extra_subjects` | `list(string)` | No | Additional GitHub OIDC `sub` claim patterns allowed to assume this role. |
| `tags` | `map(string)` | No | Additional tags for the role and policy. |

## Outputs

| Name | Description |
| --- | --- |
| `role_name` | IAM role name. |
| `role_arn` | IAM role ARN. |
| `policy_name` | IAM policy name. |
| `policy_arn` | IAM policy ARN. |

## Used By

The core infrastructure stack uses this module to create the separate build and
deploy roles consumed by GitHub Actions workflows.
