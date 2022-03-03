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
              "${aws_iam_role.code-pipeline-role.arn}"
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


resource "aws_s3_bucket" "document-bucket" {
  bucket = "${var.document-bucket-subdomain}.${var.domain_name}"
  force_destroy = true
  versioning {
    enabled = true
  }

  tags = {
    Name = "${var.document-bucket-subdomain}.${var.domain_name}"
  }
}

data "aws_s3_bucket" "web-bucket" {
  bucket = "${var.web-bucket-subdomain}.${var.domain_name}"
}
