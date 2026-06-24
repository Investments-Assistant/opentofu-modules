resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.cluster_name}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "redis" {
  name        = "${var.cluster_name}-redis-sg"
  description = "Allow Redis from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.cluster_name}-redis-sg" }
}
