resource "aws_lb_target_group" "api-service-target-group" {
  name = "${var.app_name}-api-service-tg"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.vpc.id

  health_check {
    interval = 30
    path = "/status/"
    port = 80
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    protocol = "HTTP"
    matcher = "200,202"
  }
}

resource "aws_lb" "api-service" {
  name = "${var.app_name}-api-service-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.load-balancer.id]

  dynamic "subnet_mapping" {
    for_each = [for i in range(length(values(aws_subnet.public-subnets))) : {
      subnet_id = element(values(aws_subnet.public-subnets), i).id
    }]
    content {
      subnet_id = subnet_mapping.value.subnet_id
    }
  }

  enable_deletion_protection = false

  access_logs {
    bucket = aws_s3_bucket.aws-logs.bucket
    enabled = true
  }

  tags = {
    Name = "${var.app_name}-api-service-load-balancer"
  }
}

resource "aws_lb_listener" "api-service-https" {
  load_balancer_arn = aws_lb.api-service.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.for-prod-load-balancer.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api-service-target-group.arn
  }
}

resource "aws_lb_listener" "api-service-http" {
  load_balancer_arn = aws_lb.api-service.arn
  port = "80"
  protocol = "HTTP"
  ssl_policy = ""

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_target_group_attachment" "api-service" {
  target_group_arn = aws_lb_target_group.api-service-target-group.arn
  target_id = aws_instance.primary-api-service.id
  port = 80
}
