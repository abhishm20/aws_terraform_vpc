resource "aws_acm_certificate" "for-prod-cloudfront" {
  provider    = aws.cloudfront-acm
  domain_name = var.domain_name
  subject_alternative_names = [
  "*.${var.domain_name}"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "for-stag-cloudfront" {
  provider    = aws.cloudfront-acm
  domain_name = "stag.${var.domain_name}"
  subject_alternative_names = [
  "*.stag.${var.domain_name}"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "for-prod-cloudfront-validation" {
  zone_id         = data.aws_route53_zone.public.zone_id
  name            = tolist(aws_acm_certificate.for-prod-cloudfront.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.for-prod-cloudfront.domain_validation_options)[0].resource_record_type
  records         = [tolist(aws_acm_certificate.for-prod-cloudfront.domain_validation_options)[0].resource_record_value]
  ttl             = "300"
  allow_overwrite = true
}

resource "aws_route53_record" "for-stag-cloudfront-validation" {
  zone_id         = data.aws_route53_zone.public.zone_id
  name            = tolist(aws_acm_certificate.for-stag-cloudfront.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.for-stag-cloudfront.domain_validation_options)[0].resource_record_type
  records         = [tolist(aws_acm_certificate.for-stag-cloudfront.domain_validation_options)[0].resource_record_value]
  ttl             = "300"
  allow_overwrite = true
}


resource "aws_acm_certificate" "for-prod-load-balancer" {
  domain_name = var.domain_name
  subject_alternative_names = [
  "*.${var.domain_name}"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "for-local-region-validation" {
  zone_id         = data.aws_route53_zone.public.zone_id
  name            = tolist(aws_acm_certificate.for-prod-load-balancer.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.for-prod-load-balancer.domain_validation_options)[0].resource_record_type
  records         = [tolist(aws_acm_certificate.for-prod-load-balancer.domain_validation_options)[0].resource_record_value]
  ttl             = "300"
  allow_overwrite = true
}