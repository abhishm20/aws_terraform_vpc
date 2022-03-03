resource "aws_kms_key" "kms-key-code-pipeline" {
  description = "${var.app_name}-kms-key-code-pipeline"
  deletion_window_in_days = 10
}

resource "aws_kms_grant" "kms-grant-code-pipeline" {
  name = "${var.app_name}-kms-grant-code-pipeline"
  key_id = aws_kms_key.kms-key-code-pipeline.id
  grantee_principal = aws_iam_role.code-pipeline-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}

resource "aws_kms_alias" "kms-alias-code-pipeline" {
  name = "alias/${var.app_name}-kms-alias-code-pipeline"
  target_key_id = aws_kms_key.kms-key-code-pipeline.key_id
}
