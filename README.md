# opentofu-modules

Reusable OpenTofu modules for the Investments Assistant infrastructure.

## Modules

| Module | Purpose |
| --- | --- |
| `vpc` | VPC, public/private subnets, route tables, internet gateway, and NAT gateway. |
| `eks` | EKS cluster, managed node groups, Kubernetes controllers, and EFS storage. |
| `rds` | Aurora PostgreSQL Serverless v2. |
| `elasticache` | Redis replication group and security group. |
| `ecr` | One ECR repository per application service. |
| `acm` | Optional ACM certificate and Route 53 validation records. |
| `cognito` | Cognito user pool, ALB app client, hosted UI domain, and role groups. |
| `github_actions_oidc_role` | IAM role and managed policy for GitHub Actions OIDC workflows. |
| `waf` | Regional WAF WebACL and IP allowlist for the public ALB. |
| `secrets` | IRSA role, Secrets Manager access, ECR/WAF permissions, and ALB log bucket. |

## Usage

Reference modules by subdirectory from consuming stacks:

```hcl
module "vpc" {
  source = "git::ssh://git@github.com/Investments-Assistant/opentofu-modules.git//vpc?ref=v0.0.1"

  cluster_name = var.cluster_name
  azs          = local.azs
}
```

Pin `ref` to a release tag or commit SHA. For example, `ref=v0.0.1`.

## Validation

Run these checks before publishing module changes:

```bash
tofu fmt -recursive -check
for module in acm cognito ecr eks elasticache github_actions_oidc_role rds secrets vpc waf; do
  tofu -chdir="$module" init -backend=false -input=false -reconfigure -upgrade
  tofu -chdir="$module" validate
done
```

## Releases

Run the `Release` workflow manually from the `main` branch. It runs
`semantic-release`, calculates the next version from Conventional Commits since
the latest SemVer tag, writes `CHANGELOG.md`, creates a v-prefixed tag such as
`v1.0.0`, and publishes a GitHub release. There is no version input; use the
dry-run checkbox to preview the release without committing, tagging, or
publishing.

The changelog groups commits into sections such as `New Features`, `Fixese`,
`Performance Improvements`, `Documentation`, `CI`, and `Chores`. Commit subjects
can use either `feat(scope): ...` or slash-style `feat/scope: ...` formatting.
Semantic-release reads release history from git tags, so publish the initial
`v0.0.1` tag before relying on consumer module refs pinned to that version.
