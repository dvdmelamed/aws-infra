module "dev_domain" {
  source    = "./modules/domain"
  zone_name = local.domains["dev"]

  providers = {
    aws = aws.dev
  }
}

module "staging_domain" {
  source    = "./modules/domain"
  zone_name = "staging.${local.domains["staging"]}"

  providers = {
    aws = aws.staging
  }
}

module "prod_domain" {
  source    = "./modules/domain"
  zone_name = local.domains["prod"]

  providers = {
    aws = aws.production
  }
}

resource "aws_route53_record" "staging_ns" {
  zone_id = module.prod_domain.zone_id
  name    = "staging"
  type    = "NS"
  records = module.staging_domain.name_servers
  ttl     = 60

  provider = aws.production
}

resource "aws_route53_record" "record" {
  for_each = local.dns_records
  zone_id  = module.prod_domain.zone_id
  type     = each.value.type
  name     = each.value.name
  ttl      = each.value.ttl
  records  = each.value.records

  provider = aws.production
}
