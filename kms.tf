resource "aws_kms_key" "development-kms-code-pipeline" {
  description = "${var.app_name}-kms-code-pipeline"
  deletion_window_in_days = 10
}

resource "aws_kms_grant" "development_grant_for_codepipeline" {
  name = "${var.app_name}-kms-grant-for-codepipeline"
  key_id = aws_kms_key.development-kms-code-pipeline.id
  grantee_principal = aws_iam_role.code-pipeline-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}

resource "aws_kms_alias" "development-kms-alias" {
  name = "alias/development-kms"
  target_key_id = aws_kms_key.development-kms-code-pipeline.key_id
}

resource "aws_kms_key" "deployment-kms-code-pipeline" {
  description = "${var.app_name}-kms-code-pipeline"
  deletion_window_in_days = 10
}

resource "aws_kms_grant" "deployment-grant-for-codepipeline" {
  name = "${var.app_name}-kms-grant-for-codepipeline"
  key_id = aws_kms_key.deployment-kms-code-pipeline.id
  grantee_principal = aws_iam_role.code-pipeline-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}

resource "aws_kms_alias" "deployment-kms-alias" {
  name = "alias/deployment-kms"
  target_key_id = aws_kms_key.deployment-kms-code-pipeline.key_id
}