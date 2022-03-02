locals {
  api_service_document_s3_origin_id = "S3-${aws_s3_bucket.api-service-document-bucket.bucket}"
  web_service_document_s3_origin_id = "S3-${aws_s3_bucket.web-prod-bucket.bucket}"
  pwa_service_document_s3_origin_id = "S3-${aws_s3_bucket.web-stag-bucket.bucket}"
}

resource "aws_cloudfront_origin_access_identity" "api-service-document-cloudfront-access-identity" {
  comment = "S3-${aws_s3_bucket.api-service-document-bucket.bucket}"
}

resource "aws_cloudfront_public_key" "api-service-document-cloudfront-public-key" {
  comment = "${var.app_name}-api-service-document-cloudfront-public-key"
  encoded_key = file("${path.root}/ssh_keys/api-service-document-cloudfront.pub")
  name = "${var.app_name}-api-service-document-cloudfront-public-key"
}

resource "aws_cloudfront_distribution" "api-service-document-cloudfront" {
  origin {
    domain_name = aws_s3_bucket.api-service-document-bucket.bucket_domain_name
    origin_id = local.api_service_document_s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.api-service-document-cloudfront-access-identity.cloudfront_access_identity_path
    }
  }

  enabled = true
  is_ipv6_enabled = true
  comment = "Serves documents for api-service"

  logging_config {
    include_cookies = false
    bucket = aws_s3_bucket.aws-logs.bucket_domain_name
    prefix = "api-service-cloudfront"
  }

  aliases = [
    "docs.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT"]
    cached_methods = [
      "GET",
      "HEAD"]
    target_origin_id = local.api_service_document_s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
    compress = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = ["IN"]
    }
  }

  //  trusted_signers = [aws_cloudfront_public_key.api-service-document-cloudfront-public-key]

  tags = {
    Environment = "${var.app_name}-api-service-document-cloudfront"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.for-prod-cloudfront.arn
    //    cloudfront_default_certificate = true
    ssl_support_method = "sni-only"
  }
}


resource "aws_cloudfront_origin_access_identity" "web-prod-cloudfront-access-identity" {
  comment = "S3-${aws_s3_bucket.web-prod-bucket.bucket}"
}

resource "aws_cloudfront_distribution" "web-prod-cloudfront" {
  origin {
    domain_name = aws_s3_bucket.web-prod-bucket.bucket_domain_name
    origin_id = local.web_service_document_s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web-prod-cloudfront-access-identity.cloudfront_access_identity_path
    }
  }

  enabled = true
  is_ipv6_enabled = true
  comment = "Serves web app for ${var.app_name}"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket = aws_s3_bucket.aws-logs.bucket_domain_name
    prefix = "web-prod-cloudfront"
  }

  aliases = [
    "web.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"]
    cached_methods = [
      "GET",
      "HEAD"]
    target_origin_id = local.web_service_document_s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
    compress = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = [
        "IN"]
    }
  }

  tags = {
    Environment = "${var.app_name}-web-prod-cloudfront"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.for-prod-cloudfront.arn
    ssl_support_method = "sni-only"
  }

  custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }
}


resource "aws_cloudfront_origin_access_identity" "web-stag-cloudfront-access-identity" {
  comment = "S3-${aws_s3_bucket.web-prod-bucket.bucket}"
}

resource "aws_cloudfront_distribution" "web-stag-cloudfront" {
  origin {
    domain_name = aws_s3_bucket.web-prod-bucket.bucket_domain_name
    origin_id = local.web_service_document_s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web-stag-cloudfront-access-identity.cloudfront_access_identity_path
    }
  }

  enabled = true
  is_ipv6_enabled = true
  comment = "Serves web app for ${var.app_name}"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket = aws_s3_bucket.aws-logs.bucket_domain_name
    prefix = "web-prod-cloudfront"
  }

  aliases = [
    "web.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"]
    cached_methods = [
      "GET",
      "HEAD"]
    target_origin_id = local.web_service_document_s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
    compress = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = [
        "IN"]
    }
  }

  tags = {
    Environment = "${var.app_name}-web-prod-cloudfront"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.for-stag-cloudfront.arn
    ssl_support_method = "sni-only"
  }

  custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }
}
