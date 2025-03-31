locals {
  zone_name = var.environment == "dev" ? "dev.aswinlakshmanan.me" : "demo.aswinlakshmanan.me"
}

data "aws_route53_zone" "primary" {
  name         = local.zone_name
  private_zone = false
}

resource "aws_route53_record" "app_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  # Leave name empty to create an apex alias record (i.e. dev.aswinlakshmanan.me or demo.aswinlakshmanan.me)
  name = ""
  type = "A"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}
