# variables.tf
variable "app_name" {
  default = "sl"
}
variable "region" {
  default = "ap-south-1"
}
variable "domain_name" {
  default = "saraloan.in"
}
variable "api_service_deployment_branch_name" {
  default = "master"
}
variable "rds_prod_master_instance_type" {
  default = "db.t3.medium"
}
variable "ansible_server_instance_type" {
  default = "t3.small"
}
variable "rds_prod_read_replica_instance_type" {
  default = "db.t3.small"
}
variable "mysql_username" {
  default = "root"
}
variable "mysql_password" {
  default = "ainaa007"
}
variable "mysql_db_name" {
  default = "llm_db"
}
variable "api_service_primary_instance_type" {
  default = "t3.large"
}
variable "api_service_staging_instance_type" {
  default = "t3.medium"
}

variable "api_service_bastion_host_type" {
  default = "t3.small"
}
variable "api_service_secondary_instance_type" {
  default = "t3.medium"
}
variable "api_service_git_clone_http_url" {
  default = "https://git-codecommit.ap-south-1.amazonaws.com/v1/repos/llm_server"
}
variable "api_service_git_repo_name" {
  default = "llm_server"
}
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "ubuntu_ami_id" {
  default = "ami-0cbbb3a1d5089cac3"
}
# end of variables.tf

locals {
  public_subnets = {
    "${var.region}a" = "10.0.0.0/18"
    "${var.region}b" = "10.0.64.0/18"
  }
  private_subnets = {
    "${var.region}a" = "10.0.128.0/18"
    "${var.region}b" = "10.0.192.0/18"
  }
}


