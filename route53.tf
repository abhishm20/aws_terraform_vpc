data "aws_route53_zone" "public" {
  name = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "web-prod-route53" {
  zone_id = data.aws_route53_zone.public.id
  name = "app.${var.domain_name}"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.web-prod-cloudfront.domain_name
    zone_id = aws_cloudfront_distribution.web-prod-cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "web-stag-route53" {
  zone_id = data.aws_route53_zone.public.id
  name = "app.${var.domain_name}"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.web-stag-cloudfront.domain_name
    zone_id = aws_cloudfront_distribution.web-stag-cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api-service-route53" {
  zone_id = data.aws_route53_zone.public.id
  name = "api.${var.domain_name}"
  type = "CNAME"
  ttl = "5"
  records = [
    aws_lb.api-service.dns_name]
}

resource "aws_route53_record" "api-service-document-cloudfront-route53" {
  zone_id = data.aws_route53_zone.public.id
  name = "docs.${var.domain_name}"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.api-service-document-cloudfront.domain_name
    zone_id = aws_cloudfront_distribution.api-service-document-cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}
