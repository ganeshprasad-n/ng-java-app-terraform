output "endpoint" {
  value = aws_elasticache_cluster.memcached.configuration_endpoint
}

output "cluster_id" {
  value = aws_elasticache_cluster.memcached.cluster_id
}