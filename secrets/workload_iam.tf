data "aws_iam_policy_document" "irsa_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:investments:investments-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "investments_sa" {
  name               = "${var.cluster_name}-investments-sa-role"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume.json
}

resource "aws_iam_policy" "investments_sa" {
  name = "${var.cluster_name}-investments-sa-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Read the investments/prod secret
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Resource = [var.secrets_manager_secret_arn]
      },
      {
        # Pull/push images in ECR
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken",
        ]
        Resource = concat(var.ecr_repository_arns, ["*"])
      },
      {
        # Allow associating WAF to ALB (used by Load Balancer Controller)
        Effect   = "Allow"
        Action   = ["wafv2:AssociateWebACL", "wafv2:DisassociateWebACL", "wafv2:GetWebACL"]
        Resource = [var.waf_webacl_arn, "*"]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "investments_sa" {
  role       = aws_iam_role.investments_sa.name
  policy_arn = aws_iam_policy.investments_sa.arn
}
