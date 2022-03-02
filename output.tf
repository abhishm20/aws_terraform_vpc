output "api-service-s3-access-key" {
  value = aws_iam_access_key.api-service-s3-access-key
}

output "web-prod-s3-access-key" {
  value = aws_iam_access_key.web-prod-s3-access-key
}

output "bastion-public-id" {
  value = aws_instance.bastion-host.public_ip
}

output "api-service-document-bucket" {
  value = aws_s3_bucket.api-service-document-bucket
}

output "rds-instance" {
  value = aws_db_instance.api-service
}

output "elastic-cache" {
  value = aws_elasticache_cluster.api-service
}

output "api-service-document-cloudfront-public-key" {
  value = aws_cloudfront_public_key.api-service-document-cloudfront-public-key
}

//output "sns-sms-access-key" {
//  value = aws_iam_access_key.sns-sms-access-key
//}