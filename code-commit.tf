data "aws_codecommit_repository" "api-service" {
  provider = aws.development
  repository_name = var.api_service_git_repo_name
}
