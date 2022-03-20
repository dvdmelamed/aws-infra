output "users" {
  value = {for k, v in module.aws_user: k => v.summary}
}

output "links" {
  value = {
    root = {
      aws_console_sign_in = "https://${aws_organizations_account.users.id}.signin.aws.amazon.com/console/"
    }
    dev = {
      switch_role_admin    = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.dev.id}&roleName=${urlencode(module.role_dev["admin"].role_name)}&displayName=${urlencode("Admin@dev")}"
      switch_role_readonly = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.dev.id}&roleName=${urlencode(module.role_dev["readonly"].role_name)}&displayName=${urlencode("ReadOnly@dev")}"
    }
    staging = {
      switch_role_admin    = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.staging.id}&roleName=${urlencode(module.role_staging["admin"].role_name)}&displayName=${urlencode("Admin@staging")}"
      switch_role_readonly = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.staging.id}&roleName=${urlencode(module.role_staging["readonly"].role_name)}&displayName=${urlencode("ReadOnly@staging")}"
    }
    prod = {
      switch_role_admin    = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.production.id}&roleName=${urlencode(module.role_production["admin"].role_name)}&displayName=${urlencode("Admin@production")}"
      switch_role_readonly = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.production.id}&roleName=${urlencode(module.role_production["readonly"].role_name)}&displayName=${urlencode("ReadOnly@production")}"
    }
    team1 = module.team1_account.role_name,
  }
}

output "domains" {
  value = {
    "domain-dev.io" = module.dev_domain.name_servers
    "domain.io"    = module.prod_domain.name_servers
  }
}

output "github" {
  value = {
    "dev"     = module.github-oidc-dev.role_arn
    "staging" = module.github-oidc-staging.role_arn
    "prod"    = module.github-oidc-prod.role_arn
  }
}