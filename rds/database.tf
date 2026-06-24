resource "aws_rds_cluster" "main" {
  cluster_identifier        = "${var.cluster_name}-aurora"
  engine                    = "aurora-postgresql"
  engine_mode               = "provisioned"
  engine_version            = var.engine_version
  database_name             = var.db_name
  master_username           = var.db_username
  master_password           = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.main.name
  vpc_security_group_ids    = [aws_security_group.rds.id]
  storage_encrypted         = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.cluster_name}-aurora-final"
  deletion_protection       = true

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 4.0
  }
}

resource "aws_rds_cluster_instance" "writer" {
  identifier         = "${var.cluster_name}-aurora-writer"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.main.engine
}
