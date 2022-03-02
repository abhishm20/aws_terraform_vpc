resource "aws_codedeploy_app" "api-service" {
  compute_platform = "Server"
  name = "${var.app_name}-api-service-code-deploy"
}

resource "aws_codedeploy_deployment_group" "api-service-group" {
  app_name = aws_codedeploy_app.api-service.name
  deployment_group_name = "${var.app_name}-api-service-production-group"
  service_role_arn = aws_iam_role.deployment-code-pipeline-role.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  deployment_style {
    deployment_type   = "IN_PLACE"
  }

  autoscaling_groups = [
    aws_autoscaling_group.celery-default-worker.id,
    aws_autoscaling_group.secondary-api-service.id]

  ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = aws_instance.primary-api-service.tags.Name
    }

  //  TODO set
  //  trigger_configuration {
  //    trigger_events = [
  //      "DeploymentFailure"]
  //    trigger_name = "foo-trigger"
  //    trigger_target_arn = "foo-topic-arn"
  //  }

  auto_rollback_configuration {
    enabled = false
  }

  //  TODO set
  //  alarm_configuration {
  //    alarms = [
  //      "my-alarm-name"]
  //    enabled = true
  //  }
}