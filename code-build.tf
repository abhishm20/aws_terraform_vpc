resource "aws_codebuild_project" "api-service-code-build" {
  name = "${var.app_name}-api-service-code-build"
  service_role = aws_iam_role.code-pipeline-role.arn

  artifacts {
    location = aws_s3_bucket.code-pipeline-artifacts-bucket.bucket
    type = "S3"
    path = "/build"
    packaging = "ZIP"
    namespace_type = "BUILD_ID"
    name = "api-service"
  }


  cache {
    type = "S3"
    location = aws_s3_bucket.code-pipeline-artifacts-bucket.bucket
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:5.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name = "BUCKET"
      value = var.api_service_git_clone_http_url
    }
  }

  source {
    type = "CODECOMMIT"
    location = var.api_service_git_clone_http_url
    git_clone_depth = 1
  }

  logs_config {
    cloudwatch_logs {
      group_name = "build-log-group"
      stream_name = "log-stream"
    }
  }
}
