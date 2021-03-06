resource "aws_elasticache_subnet_group" "api-service-elastic-cache-subnet-group" {
  name       = "${var.app_name}-api-service-elastic-cache-subnet-group"
  subnet_ids = [element(values(aws_subnet.private-subnets), 1).id]
}

resource "aws_elasticache_cluster" "api-service-elastic-cache-cluster" {
  cluster_id           = "${var.app_name}-api-service-elastic-cache-cluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  security_group_ids = [aws_security_group.api-service-elastic-cache-security-group.id]
  subnet_group_name = aws_elasticache_subnet_group.api-service-elastic-cache-subnet-group.name
  //  engine_version = "6.x"
  port = 6379
}

