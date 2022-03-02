data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "aws-logs" {
  bucket = "${var.app_name}-aws-resource-logs"
  acl = "private"
  force_destroy = true
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.app_name}-aws-resource-logs/*",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_elb_service_account.main.id}:root"
        ]
      }
    }
  ]
}
POLICY

  tags = {
    Name = "${var.app_name}-aws-resource-logs"
  }
}

resource "aws_s3_bucket" "code-pipeline-artifacts-bucket" {
  bucket = "${var.app_name}-code-pipeline-artifacts-bucket"
  acl = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": [
              "${aws_iam_role.deployment-code-pipeline-role.arn}"
            ]
        },
        "Action": [
            "s3:GetObject",
            "s3:PutObject",
            "s3:PutObjectAcl"

        ],
        "Resource": [
            "arn:aws:s3:::${var.app_name}-code-pipeline-artifacts-bucket/*"
        ]
    }
  ]
}
POLICY

  tags = {
    Name = "${var.app_name}-code-pipeline-artifacts-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "code-pipeline-artifacts-bucket-ownership" {
  bucket = aws_s3_bucket.code-pipeline-artifacts-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket" "api-service-document-bucket" {
  bucket = "${var.app_name}-api-service-document-bucket"
  force_destroy = true
  versioning {
    enabled = true
  }

  tags = {
    Name = "${var.app_name}-api-service-document-bucket"
  }
}

resource "aws_s3_bucket" "web-prod-bucket" {
  bucket = "${var.app_name}-web-prod-bucket"
  acl = "public-read"
  force_destroy = true

  website {
    error_document = "index.html"
    index_document = "index.html"
  }
  tags = {
    Name = "${var.app_name}-web-prod-bucket"
  }
}

resource "aws_s3_bucket" "web-stag-bucket" {
  bucket = "${var.app_name}-web-stag-bucket"
  acl = "public-read"
  force_destroy = true

  website {
    error_document = "index.html"
    index_document = "index.html"
  }

  tags = {
    Name = "${var.app_name}-web-stag-bucket"
  }
}