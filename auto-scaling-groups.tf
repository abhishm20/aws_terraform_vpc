resource "aws_autoscaling_group" "secondary-api-auto-scaling" {
  name = "${var.app_name}-secondary-api-auto-scaling"
  health_check_type = "ELB"
  health_check_grace_period = 300
  termination_policies = [
    "OldestInstance"]
  launch_template {
    id = aws_launch_template.secondary-api-launch-template.id
    version = "$Latest"
  }
  min_size = 0
  max_size = 0

  lifecycle {
    create_before_destroy = true
  }
  target_group_arns = [
    aws_lb_target_group.api-service-target-group.arn]

  tag {
    key = "Name"
    value = "${var.app_name}-secondary-api-auto-scaling"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "celery-worker-auto-scaling" {
  name = "${var.app_name}-celery-worker-auto-scaling"
  health_check_type = "ELB"
  health_check_grace_period = 300
  termination_policies = [
    "OldestInstance"]
  launch_template {
    id = aws_launch_template.celery-worker-launch-template.id
    version = "$Latest"
  }
  min_size = 1
  max_size = 1

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.app_name}-celery-worker-auto-scaling"
    propagate_at_launch = true
  }
}
