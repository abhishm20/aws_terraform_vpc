resource "aws_instance" "bastion-host" {
  instance_type = var.api_service_bastion_host_type
  ami = var.ubuntu_ami_id
  subnet_id = element(values(aws_subnet.public-subnets), 0).id
  vpc_security_group_ids = [
    aws_security_group.bastion-host.id]
  key_name = aws_key_pair.bastion-host.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  user_data = file("${path.root}/init_scripts/bastion-host.sh")
  tags = {
    "Name" = "${var.app_name}-bastion-host"
  }
}

resource "aws_instance" "primary-api-service" {
  instance_type = var.api_service_primary_instance_type
  ami = var.ubuntu_ami_id
  subnet_id = element(values(aws_subnet.private-subnets), 0).id
  vpc_security_group_ids = [
    aws_security_group.api-service.id]
  key_name = aws_key_pair.api-service.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "50"
  }
  associate_public_ip_address = false
  user_data = file("${path.root}/init_scripts/primary-api-service.sh")
  tags = {
    "Name" = "${var.app_name}-primary-api-service"
  }
  iam_instance_profile = aws_iam_instance_profile.ec2-code-deploy-instance-profile.name
}


resource "aws_instance" "staging-api-service" {
  instance_type = var.api_service_staging_instance_type
  ami = var.ubuntu_ami_id
  key_name = aws_key_pair.staging-api-service.key_name
  ebs_optimized = false
  root_block_device {
    volume_size = "50"
  }
  tags = {
    "Name" = "${var.app_name}-staging-api-service"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.staging-api-service.id
  allocation_id = aws_eip.api-service-stag-ip
}