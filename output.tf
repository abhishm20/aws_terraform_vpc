output "api-service-document-bucket-access-key" {
  value = aws_iam_access_key.api-service-document-bucket-access-key
}

output "web-bucket-access-key" {
  value = aws_iam_access_key.web-bucket-access-key
}

output "bastion-public-id" {
  value = aws_instance.bastion-host.public_ip
}

output "api-service-document-bucket" {
  value = data.aws_s3_bucket.document-bucket
}

output "rds-instance" {
  value = aws_db_instance.db-master-rds-instance
}

output "api-service-elastic-cache" {
  value = aws_elasticache_cluster.api-service-elastic-cache-cluster
}

output "document-bucket-cloudfront-public-key" {
  value = aws_cloudfront_public_key.document-bucket-cloudfront-public-key
}

//output "sns-sms-access-key" {
//  value = aws_iam_access_key.sns-sms-access-key
//}