// Used for pipeline
resource "aws_iam_role" "code-pipeline-role" {
  name = "${var.app_name}-code-pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com",
        "Service": "codebuild.amazonaws.com",
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "code-pipeline-policy" {
  role = aws_iam_role.code-pipeline-role.id
  name = "${var.app_name}-code-pipeline-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:*"
      ],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": ["kms:*"],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.code-pipeline-artifacts-bucket.arn}",
        "${aws_s3_bucket.code-pipeline-artifacts-bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "sts:*"
      ],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": ["iam:PassRole"],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:CreateTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

// Used for EC2 Code deployment
resource "aws_iam_role" "ec2-code-deploy-role" {
  name = "${var.app_name}-ec2-code-deploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
          "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2-code-deploy-role-policy" {
  role = aws_iam_role.ec2-code-deploy-role.id
  name = "${var.app_name}-ec2-code-deploy-role-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Resource": [
        "${aws_s3_bucket.code-pipeline-artifacts-bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2-code-deploy-instance-profile" {
  name = "${var.app_name}-ec2-code-deploy-instance-profile"
  role = aws_iam_role.ec2-code-deploy-role.name
}

// api service documents
resource "aws_iam_access_key" "api-service-document-bucket-access-key" {
  user = aws_iam_user.api-service-document-bucket-access-user.name
  //  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_iam_user" "api-service-document-bucket-access-user" {
  name = "${var.app_name}-api-service-document-bucket-access-user"
  path = "/system/"
}

resource "aws_iam_user_policy" "api-service-document-bucket-access-user-policy" {
  name = "${var.app_name}-api-service-document-bucket-access-user-policy"
  user = aws_iam_user.api-service-document-bucket-access-user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObjectAcl",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${data.aws_s3_bucket.document-bucket.arn}/*"
      ]
    }
  ]
}
EOF
}


// production s3 access
resource "aws_iam_access_key" "web-bucket-access-key" {
  user = aws_iam_user.web-bucket-access-user.name
  //  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_iam_user" "web-bucket-access-user" {
  name = "${var.app_name}-web-bucket-access-user"
  path = "/system/"
}

resource "aws_iam_user_policy" "web-bucket-access-user-policy" {
  name = "${var.app_name}-web-bucket-access-user-policy"
  user = aws_iam_user.web-bucket-access-user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${data.aws_s3_bucket.web-bucket.arn}",
        "${data.aws_s3_bucket.web-bucket.arn}/*",
      ]
    },
    {
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_cloudfront_distribution.web-bucket-cloudfront.arn}",
      ]
    }
  ]
}
EOF
}


resource "aws_iam_role" "sns-sms-cloudwatch-logs" {
  name = "${var.app_name}-sns-sms-logs-bucket"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
          "Service": "sns.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "sns-sms-cloudwatch-logs-policy" {
  role = aws_iam_role.sns-sms-cloudwatch-logs.id
  name = "${var.app_name}-sns-sms-cloudwatch-logs-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:PutMetricFilter",
                "logs:PutRetentionPolicy"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}
