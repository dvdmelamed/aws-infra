output "zone_id" {
  value = aws_route53_zone.domain_zone.id
}

output "name_servers" {
  value = aws_route53_zone.domain_zone.name_servers
}
