locals {
  # Choose the correct zone name based on the environment
  zone_name = var.environment == "dev" ? var.route53_zone_name_dev : var.route53_zone_name_demo
}

data "aws_route53_zone" "primary" {
  name         = local.zone_name
  private_zone = false
}

resource "aws_route53_record" "app_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.route53_record_name # Empty string creates an apex alias record
  type    = var.route53_record_type

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}
