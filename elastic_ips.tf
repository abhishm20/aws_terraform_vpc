resource "aws_eip" "api-service-prod-ip" {
  vpc              = true
//  public_ipv4_pool = "ipv4pool-ec2-012345"

  tags = {
    Name = "${var.app_name}-api-service-prod-ip"
  }
}


resource "aws_eip" "api-service-stag-ip" {
  vpc              = true
//  public_ipv4_pool = "ipv4pool-ec2-012345"

  tags = {
    Name = "${var.app_name}-api-service-stag-ip"
  }
}


//data "aws_eip" "nat_public_ip" {
//  public_ip = var.elastic_nat_public_ip
//}
