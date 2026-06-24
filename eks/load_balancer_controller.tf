data "aws_iam_policy_document" "albc_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "albc" {
  name               = "${var.cluster_name}-albc-role"
  assume_role_policy = data.aws_iam_policy_document.albc_assume.json
}

resource "aws_iam_policy" "albc" {
  name   = "${var.cluster_name}-albc-policy"
  policy = file("${path.module}/albc-iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "albc" {
  role       = aws_iam_role.albc.name
  policy_arn = aws_iam_policy.albc.arn
}
