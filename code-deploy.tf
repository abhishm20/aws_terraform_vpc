resource "aws_codedeploy_app" "api-service-code-deploy" {
  compute_platform = "Server"
  name = "${var.app_name}-api-service-code-deploy"
}

resource "aws_codedeploy_deployment_group" "api-service-deployment-group" {
  app_name = aws_codedeploy_app.api-service-code-deploy.name
  deployment_group_name = "${var.app_name}-api-service-deployment-group"
  service_role_arn = aws_iam_role.code-pipeline-role.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  deployment_style {
    deployment_type = "IN_PLACE"
  }

  autoscaling_groups = [
    aws_autoscaling_group.celery-worker-auto-scaling.id,
    aws_autoscaling_group.secondary-api-auto-scaling.id]

  ec2_tag_filter {
    key = "Name"
    type = "KEY_AND_VALUE"
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