# security-groups.tf
# Create VPC/Subnet/Security Group/Network ACL

# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.app_name}-vpc"
  }
}

# VPC Flow logs
resource "aws_flow_log" "vpc-flow-log" {
  log_destination      = aws_s3_bucket.aws-logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
}


# Create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_name}-internet-gateway"
  }
}

# Create subnets
resource "aws_subnet" "public-subnets" {
  for_each   = local.public_subnets
  cidr_block = each.value
  vpc_id     = aws_vpc.vpc.id

  map_public_ip_on_launch = true
  availability_zone       = each.key

  tags = {
    Name = "${var.app_name}-public-subnet-${substr(each.key, length(each.key) - 1, length(each.key))}"
  }
  depends_on = [
  aws_internet_gateway.internet-gateway]
}

resource "aws_subnet" "private-subnets" {
  for_each   = local.private_subnets
  cidr_block = each.value
  vpc_id     = aws_vpc.vpc.id

  map_public_ip_on_launch = true
  availability_zone       = each.key

  tags = {
    Name = "${var.app_name}-private-subnet-${substr(each.key, length(each.key) - 1, length(each.key))}"
  }
  depends_on = [
  aws_internet_gateway.internet-gateway]
}


# Create NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  subnet_id     = element(values(aws_subnet.public-subnets), 1).id
  allocation_id = aws_eip.api-service-elastic-ip.id
  tags = {
    "Name" = "${var.app_name}_nat_gateway"
  }
}

# Create Route Tables
resource "aws_default_route_table" "public-route-table" {
  default_route_table_id = aws_vpc.vpc.main_route_table_id

  tags = {
    "Name" = "${var.app_name}_public_route_table"
  }
}

resource "aws_route" "public-route" {
  route_table_id         = aws_default_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gateway.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public-table-association" {
  count          = length(keys(local.public_subnets))
  subnet_id      = element(values(aws_subnet.public-subnets), count.index).id
  route_table_id = aws_default_route_table.public-route-table.id
}


resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.app_name}_private_route_table"
  }
}

resource "aws_route_table_association" "private-table-association" {
  count          = length(keys(local.private_subnets))
  subnet_id      = element(values(aws_subnet.private-subnets), count.index).id
  route_table_id = aws_route_table.private-route-table.id
}


resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway.id

  timeouts {
    create = "5m"
  }
}
