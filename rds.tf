resource "aws_db_subnet_group" "db-master-subnet-group" {
  name = "${var.app_name}-db-master-subnet-group"
  subnet_ids = [
    element(values(aws_subnet.private-subnets), 0).id,
    element(values(aws_subnet.private-subnets), 1).id]

  tags = {
    Name = "${var.app_name}-db-master-subnet-group"
  }
}

resource "aws_db_subnet_group" "db-read-replica-subnet-group" {
  name = "${var.app_name}-db-read-replica-subnet-group"
  subnet_ids = [
    element(values(aws_subnet.public-subnets), 0).id,
    element(values(aws_subnet.public-subnets), 1).id]

  tags = {
    Name = "${var.app_name}-db-read-replica-subnet-group"
  }
}



resource "aws_db_instance" "db-master-rds-instance" {
  allocated_storage = 30
  max_allocated_storage = 50
  engine = "mysql"
  engine_version = "8.0"
  instance_class = var.rds_master_instance_type
  name = var.mysql_db_name
  username = var.mysql_username
  password = var.mysql_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true

  db_subnet_group_name = aws_db_subnet_group.db-master-subnet-group.name
  apply_immediately = true
  maintenance_window = "Sun:03:00-Sun:03:30"
  backup_retention_period = 20
  backup_window = "03:30-04:00"
  auto_minor_version_upgrade = true
  performance_insights_enabled = true
  vpc_security_group_ids = [aws_security_group.db-master-rds.id]
  identifier = "${var.app_name}-db-master-rds-instance"
}

resource "aws_db_instance" "db-read-replica-rds-instance" {
  replicate_source_db = aws_db_instance.db-master-rds-instance.identifier
  allocated_storage = 30
  max_allocated_storage = 50
  engine = "mysql"
  engine_version = "8.0"
  instance_class = var.rds_read_replica_instance_type
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
  vpc_security_group_ids = [aws_security_group.db-read-replica-rds.id]
  identifier = "${var.app_name}-db-read-replica-rds-instance"
}
