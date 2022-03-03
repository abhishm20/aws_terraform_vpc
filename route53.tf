data "aws_route53_zone" "public" {
  name = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "web-bucket-route53" {
  zone_id = data.aws_route53_zone.public.id
  name = "${var.web-bucket-subdomain}.${var.domain_name}"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.web-bucket-cloudfront.domain_name
    zone_id = aws_cloudfront_distribution.web-bucket-cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api-service-route53" {
  zone_id = data.aws_route53_zone.public.id
  name = "${var.api-service-subdomain}.${var.domain_name}"
  type = "CNAME"
  ttl = "5"
  records = [
    aws_lb.api-service-load-balancer.dns_name]
}

resource "aws_route53_record" "api-service-document-cloudfront-route53" {
  zone_id = data.aws_route53_zone.public.id
  name = "${var.document-bucket-subdomain}.${var.domain_name}"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.document-bucket-cloudfront.domain_name
    zone_id = aws_cloudfront_distribution.document-bucket-cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}
