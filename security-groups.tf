// TODO fix cidr blocks

resource "aws_security_group" "bastion-host-security-group" {
  name = "${var.app_name}-bastion-host-security-group"
  description = "Bastion Host Security Group"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = "${var.app_name}-bation-host-security-group"
  }
}

resource "aws_security_group" "api-service-load-balancer-security-group" {
  name = "${var.app_name}-load-balancer-security-group"
  description = "Allow HTTP & HTTPS traffic"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-load-balancer-security-group"
  }
}

resource "aws_security_group" "api-service-security-group" {
  name = "${var.app_name}-api-service-security-group"
  description = "Allow only HTTP & SSH"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-api-service-security-group"
  }
}

resource "aws_security_group" "ansible-security-group" {
  name = "${var.app_name}-ansible-security-group"
  description = "Allow only HTTP & SSH"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-api-service-security-group"
  }
}

resource "aws_security_group" "celery-worker-security-group" {
  name = "${var.app_name}-celery-worker-security-group"
  description = "Allow SSH"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-celery-worker-security-group"
  }
}

resource "aws_security_group" "db-master-rds" {
  name = "${var.app_name}-db-master-rds-security-grpup"
  description = "Allow SSH"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [
      "10.0.128.0/18",
      "10.0.192.0/18"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-db-master-rds-security-grpup"
  }
}


resource "aws_security_group" "db-read-replica-rds" {
  name = "${var.app_name}-db-read-replica-rds-security-grpup"
  description = "Allow SSH"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-db-read-replica-rds-security-grpup"
  }
}

resource "aws_security_group" "api-service-elastic-cache-security-group" {
  name = "${var.app_name}-api-service-elastic-cache-security-group"
  description = "Allow only 6379"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = [
      "10.0.128.0/18",
      "10.0.192.0/18"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-api-service-elastic-cache-security-group"
  }
}
