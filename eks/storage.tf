resource "aws_efs_file_system" "reports" {
  encrypted = true
  tags      = { Name = "${var.cluster_name}-reports-efs" }
}

resource "aws_security_group" "efs" {
  name        = "${var.cluster_name}-efs-sg"
  description = "Allow NFS from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.main.vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_mount_target" "reports" {
  count           = length(var.private_subnet_ids)
  file_system_id  = aws_efs_file_system.reports.id
  subnet_id       = var.private_subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_iam_policy" "efs_csi" {
  name = "${var.cluster_name}-efs-csi-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["elasticfilesystem:*"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role" "efs_csi" {
  name = "${var.cluster_name}-efs-csi-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:efs-csi-controller-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "efs_csi" {
  role       = aws_iam_role.efs_csi.name
  policy_arn = aws_iam_policy.efs_csi.arn
}
