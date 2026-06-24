locals {
  oidc_provider_url = trimsuffix(replace(var.oidc_provider_url, "https://", ""), "/")
  branch_subjects = [
    for branch in var.allowed_branches :
    "repo:${var.github_owner}/${var.github_repository}:ref:refs/heads/${branch}"
  ]
  allowed_subjects = distinct(concat(local.branch_subjects, var.extra_subjects))
}
