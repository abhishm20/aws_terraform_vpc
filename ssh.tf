resource "aws_key_pair" "bastion-host" {
  key_name   = "${var.app_name}-bastion-host"
  public_key = file("${path.root}/ssh_keys/bastion_host.pub")
}

resource "aws_key_pair" "api-service" {
  key_name   = "${var.app_name}-api-service"
  public_key = file("${path.root}/ssh_keys/api_service.pub")
}

resource "aws_key_pair" "staging-api-service" {
  key_name   = "${var.app_name}-staging-api-service"
  public_key = file("${path.root}/ssh_keys/staging_api_service.pub")
}