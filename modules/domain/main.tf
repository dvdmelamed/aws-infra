resource "aws_route53_zone" "domain_zone" {
  name          = var.zone_name
  force_destroy = false
}
