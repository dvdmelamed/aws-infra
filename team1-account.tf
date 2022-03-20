module "team1_account" {
  source               = "./modules/custom-account"
  account_name         = local.dev_accounts["team1"]["name"]
  account_owner        = local.dev_accounts["team1"]["owner"]
  trusted_account_id   = aws_organizations_account.users.id
  domain               = local.domains["dev"]
  subdomain            = local.dev_accounts["team1"]["subdomain"]
  roles                = local.roles
  github_organisations = local.github_organisations
  full_repository_name = local.full_repository_name
  organization_unit_id = aws_organizations_organizational_unit.sandbox.id
}

module "team1_group" {
  source     = "./modules/user-group"
  group_name = "Team 1"

  assume_role_arns = [
    module.team1_account.role["admin"].role_arn,
    module.team1_account.role["readonly"].role_arn,
  ]

  providers = {
    aws = aws.users
  }
}

resource "aws_route53_record" "custom_bandit_ns" {
  zone_id = module.dev_domain.zone_id
  name    = local.dev_accounts["team1"]["subdomain"]
  type    = "NS"
  records = module.team1_account.name_servers
  ttl     = 60

  provider = aws.dev
}