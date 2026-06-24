resource "aws_db_subnet_group" "main" {
  name       = "${var.cluster_name}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "rds" {
  name        = "${var.cluster_name}-rds-sg"
  description = "Allow PostgreSQL from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.cluster_name}-rds-sg" }
}
