//resource "aws_sns_sms_preferences" "sms_preferences" {
//  monthly_spend_limit = 150
//  usage_report_s3_bucket = aws_s3_bucket.aws-logs.bucket
//  delivery_status_iam_role_arn = aws_iam_role.sns-sms-cloudwatch-logs.arn
//  default_sms_type = "Transactional"
//}