//resource "aws_launch_template" "primary-api-service" {
//  name = "${var.app_name}-primary-api-service-launch-template"
//  ebs_optimized = true
//  image_id = var.ubuntu_ami_id
//  instance_initiated_shutdown_behavior = "terminate"
//  instance_type = "t3.medium"
//  key_name = aws_key_pair.ansible-hosts-key.key_name
//  update_default_version = true
//  user_data = filebase64("${path.root}/init_scripts/primary-api-service.sh")
//  network_interfaces {
//    subnet_id = element(values(aws_subnet.private-subnets), 0).id
//    security_groups = [
//      aws_security_group.api-service.id]
//    delete_on_termination = true
//    associate_public_ip_address = false
//  }
//  tag_specifications {
//    resource_type = "instance"
//    tags = {
//      Name = "${var.app_name}-primary-api-service"
//    }
//  }
//  block_device_mappings {
//    device_name = "/dev/sda1"
//    ebs {
//      volume_size = 30
//    }
//  }
//  iam_instance_profile {
//    arn = aws_iam_instance_profile.ec2-code-deploy-instance-profile.arn
//  }
//
//  # we don't want to create a new template just because there is a newer AMI
////  lifecycle {
////    ignore_changes = [
////      image_id,
////    ]
////  }
//}

resource "aws_launch_template" "secondary-api-service" {
  name = "${var.app_name}-secondary-api-service-launch-template"
  ebs_optimized = true
  image_id = var.ubuntu_ami_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.medium"
  key_name = aws_key_pair.ansible-hosts-key.key_name
  update_default_version = true
  user_data = filebase64("${path.root}/init_scripts/secondary-api-service.sh")
  network_interfaces {
    subnet_id = element(values(aws_subnet.private-subnets), 0).id
    security_groups = [
      aws_security_group.api-service.id]
    delete_on_termination = true
    associate_public_ip_address = false
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.app_name}-api-service"
    }
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 30
    }
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2-code-deploy-instance-profile.arn
  }

  # we don't want to create a new template just because there is a newer AMI
//  lifecycle {
//    ignore_changes = [
//      image_id,
//    ]
//  }
}

resource "aws_launch_template" "celery-default-worker" {
  name = "${var.app_name}-celery-default-worker-launch-template"
  ebs_optimized = true
  image_id = var.ubuntu_ami_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.medium"
  key_name = aws_key_pair.ansible-hosts-key.key_name
  update_default_version = true
  user_data = filebase64("${path.root}/init_scripts/celery-default-worker.sh")
  network_interfaces {
    subnet_id = element(values(aws_subnet.private-subnets), 0).id
    security_groups = [
      aws_security_group.celery-worker.id]
    delete_on_termination = true
    associate_public_ip_address = false
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.app_name}-celery-default-worker"
    }
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 30
    }
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2-code-deploy-instance-profile.arn
  }

  # we don't want to create a new template just because there is a newer AMI
//  lifecycle {
//    ignore_changes = [
//      image_id,
//    ]
//  }
}
