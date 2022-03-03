//resource "aws_iam_role" "code-build-role" {
//  name = "${var.app_name}-code-build-role"
//
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Effect": "Allow",
//      "Principal": {
//        "Service": "codebuild.amazonaws.com"
//      },
//      "Action": "sts:AssumeRole"
//    }
//  ]
//}
//EOF
//}
//
//resource "aws_iam_role_policy" "code-build-policy" {
//  role = aws_iam_role.code-build-role.name
//  name = "${var.app_name}-code-build-policy"
//  policy = <<POLICY
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//        "Effect": "Allow",
//        "Action": [
//            "ec2:CreateNetworkInterface",
//            "ec2:DescribeDhcpOptions",
//            "ec2:DescribeNetworkInterfaces",
//            "ec2:DeleteNetworkInterface",
//            "ec2:DescribeSubnets",
//            "ec2:DescribeSecurityGroups",
//            "ec2:DescribeVpcs"
//        ],
//        "Resource": "*"
//    },
//    {
//      "Effect": "Allow",
//      "Action": [
//        "codebuild:BatchGetBuilds",
//        "codebuild:StartBuild"
//      ],
//      "Resource": "*"
//    },
//    {
//      "Effect":"Allow",
//      "Action": ["kms:*"],
//      "Resource": "*"
//    },
//    {
//      "Effect": "Allow",
//      "Resource": [
//        "*"
//      ],
//      "Action": [
//        "logs:CreateLogGroup",
//        "logs:CreateLogStream",
//        "logs:PutLogEvents"
//      ]
//    },
//    {
//      "Effect": "Allow",
//      "Resource": "*",
//      "Action": [
//          "codecommit:GitPull"
//      ]
//    },
//    {
//      "Effect": "Allow",
//      "Action": [
//        "s3:GetObject",
//        "s3:PutObject",
//        "s3:PutObjectAcl"
//      ],
//      "Resource": [
//        "${aws_s3_bucket.code-pipeline-artifacts-bucket.arn}/*"
//      ]
//    }
//  ]
//}
//POLICY
//}


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
        "Service": "codebuild.amazonaws.com"
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
resource "aws_iam_access_key" "api-service-s3-access-key" {
  user = aws_iam_user.api-service-s3-access.name
  //  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_iam_user" "api-service-s3-access" {
  name = "${var.app_name}-api-service-s3-access"
  path = "/system/"
}

resource "aws_iam_user_policy" "api-service-s3-access-user" {
  name = "${var.app_name}-api-service-s3-access-user"
  user = aws_iam_user.api-service-s3-access.name

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
        "${aws_s3_bucket.api-service-document-bucket.arn}/*"
      ]
    }
  ]
}
EOF
}


// production s3 access
resource "aws_iam_access_key" "web-prod-s3-access-key" {
  user = aws_iam_user.web-prod-s3-access.name
  //  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_iam_user" "web-prod-s3-access" {
  name = "${var.app_name}-web-prod-s3-access"
  path = "/system/"
}

resource "aws_iam_user_policy" "web-prod-s3-access-user" {
  name = "${var.app_name}-web-prod-s3-access-user"
  user = aws_iam_user.web-prod-s3-access.name

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
        "${aws_s3_bucket.web-prod-bucket.arn}",
        "${aws_s3_bucket.web-prod-bucket.arn}/*",
      ]
    },
    {
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_cloudfront_distribution.web-stag-cloudfront.arn}",
      ]
    }
  ]
}
EOF
}

// staging s3 access
resource "aws_iam_access_key" "web-stag-s3-access-key" {
  user = aws_iam_user.web-stag-s3-access.name
  //  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_iam_user" "web-stag-s3-access" {
  name = "${var.app_name}-web-stag-s3-access"
  path = "/system/"
}

resource "aws_iam_user_policy" "web-stag-s3-access-user" {
  name = "${var.app_name}-web-stag-s3-access-user"
  user = aws_iam_user.web-stag-s3-access.name

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
        "${aws_s3_bucket.web-stag-bucket.arn}",
        "${aws_s3_bucket.web-stag-bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_cloudfront_distribution.web-stag-cloudfront.arn}"
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
