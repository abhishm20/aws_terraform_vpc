resource "aws_db_subnet_group" "production" {
  name = "${var.app_name}-production-db-subnet"
  subnet_ids = [
    element(values(aws_subnet.private-subnets), 0).id,
    element(values(aws_subnet.private-subnets), 1).id]

  tags = {
    Name = "${var.app_name}-production-db-subnet"
  }
}

resource "aws_db_subnet_group" "read-replica" {
  name = "${var.app_name}-read-replica-db-subnet"
  subnet_ids = [
    element(values(aws_subnet.public-subnets), 0).id,
    element(values(aws_subnet.public-subnets), 1).id]

  tags = {
    Name = "${var.app_name}-read-replica-db-subnet"
  }
}



resource "aws_db_instance" "api-service" {
  allocated_storage = 30
  max_allocated_storage = 50
  engine = "mysql"
  engine_version = "8.0"
  instance_class = var.rds_prod_master_instance_type
  name = var.mysql_db_name
  username = var.mysql_username
  password = var.mysql_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true

  db_subnet_group_name = aws_db_subnet_group.production.id
  apply_immediately = true
  maintenance_window = "Sun:03:00-Sun:03:30"
  backup_retention_period = 20
  backup_window = "03:30-04:00"
  auto_minor_version_upgrade = true
  performance_insights_enabled = true
  vpc_security_group_ids = [aws_security_group.api-service-rds.id]
  identifier = "${var.app_name}-api-service-db"
}

resource "aws_db_instance" "api-service-read-replica" {
  replicate_source_db = aws_db_instance.api-service.identifier
  allocated_storage = 30
  max_allocated_storage = 50
  engine = "mysql"
  engine_version = "8.0"
  instance_class = var.rds_prod_read_replica_instance_type
  name = var.mysql_db_name
  username = var.mysql_username
  password = var.mysql_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true

  publicly_accessible = true
//  db_subnet_group_name = aws_db_subnet_group.read-replica.id
  apply_immediately = true
  maintenance_window = "Sun:03:00-Sun:03:30"
  backup_retention_period = 20
  backup_window = "03:30-04:00"
  auto_minor_version_upgrade = true
  vpc_security_group_ids = [aws_security_group.api-service-read-replica-rds.id]
  identifier = "${var.app_name}-api-service-read-replica"
}
