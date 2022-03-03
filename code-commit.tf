data "aws_codecommit_repository" "api-service" {
  repository_name = var.api_service_git_repo_name
}
