resource "aws_eip" "api-service-elastic-ip" {
  vpc = true

  tags = {
    Name = "${var.app_name}-api-service-elastic-ip"
  }
}
