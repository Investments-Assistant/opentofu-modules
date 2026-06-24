resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.cluster_name}-redis"
  description          = "Redis for investments assistant"

  node_type                  = var.node_type
  num_cache_clusters         = 1
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = [aws_security_group.redis.id]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = local.auth_token != null
  auth_token                 = local.auth_token

  automatic_failover_enabled = false

  apply_immediately = true
}
