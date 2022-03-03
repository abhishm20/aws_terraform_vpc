resource "aws_instance" "bastion-host" {
  instance_type = var.api_service_bastion_host_type
  ami = var.ubuntu_ami_id
  subnet_id = element(values(aws_subnet.public-subnets), 0).id
  vpc_security_group_ids = [
    aws_security_group.bastion-host-security-group.id]
  key_name = aws_key_pair.bastion-host.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "${var.app_name}-bastion-host"
  }
}


resource "aws_instance" "ansible-server" {
  instance_type = var.ansible_server_instance_type
  ami = var.ubuntu_ami_id
  subnet_id = element(values(aws_subnet.private-subnets), 0).id
  vpc_security_group_ids = [
    aws_security_group.ansible-security-group.id]
  key_name = aws_key_pair.ansible-server-key.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "50"
  }
  associate_public_ip_address = true
  user_data = file("${path.root}/init_scripts/ansible-server.sh")
  tags = {
    "Name" = "${var.app_name}-ansible-server"
  }
}

resource "aws_instance" "primary-api-service" {
  instance_type = var.api_service_primary_instance_type
  ami = var.ubuntu_ami_id
  subnet_id = element(values(aws_subnet.private-subnets), 0).id
  vpc_security_group_ids = [
    aws_security_group.api-service-security-group.id]
  key_name = aws_key_pair.ansible-hosts-key.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "50"
  }
  associate_public_ip_address = false
  user_data = file("${path.root}/init_scripts/primary-api.sh")
  tags = {
    "Name" = "${var.app_name}-primary-api-service"
  }

  iam_instance_profile = aws_iam_instance_profile.ec2-code-deploy-instance-profile.name
}
