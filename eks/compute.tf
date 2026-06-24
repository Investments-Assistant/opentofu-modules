resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.k8s_version
  role_arn = aws_iam_role.cluster.arn

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-workers"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.node_instance_type]

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config { max_unavailable = 1 }

  depends_on = [aws_iam_role_policy_attachment.node_worker]
}

resource "aws_eks_node_group" "llm" {
  count = var.enable_llm_node_group ? 1 : 0

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-llm"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.llm_node_instance_type]

  labels = {
    workload = "llm"
  }

  taint {
    key    = "workload"
    value  = "llm"
    effect = "NO_SCHEDULE"
  }

  scaling_config {
    desired_size = var.llm_node_desired_size
    min_size     = var.llm_node_min_size
    max_size     = var.llm_node_max_size
  }

  update_config { max_unavailable = 1 }

  depends_on = [aws_iam_role_policy_attachment.node_worker]
}
