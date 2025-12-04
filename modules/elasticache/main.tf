resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project_name}-elasticache-subnet-group-${var.environment}"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project_name}-elasticache-subnet-group"
    Environment = var.environment
  }
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "${var.project_name}-memcached-${var.environment}"
  engine               = "memcached"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = var.security_groups

  tags = {
    Name        = "${var.project_name}-memcached"
    Environment = var.environment
  }
}