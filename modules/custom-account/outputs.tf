output role {
 value = module.iam_role
}

output role_admin_arn {
  value = module.iam_role["admin"].role_arn
}

output role_readonly_arn {
  value = module.iam_role["readonly"].role_arn
}

output "role_name" {
  value = {
    switch_role_admin    = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.account.id}&roleName=${urlencode(module.iam_role["admin"].role_name)}&displayName=${urlencode("Admin@")}${var.subdomain}"
    switch_role_readonly = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.account.id}&roleName=${urlencode(module.iam_role["readonly"].role_name)}&displayName=${urlencode("ReadOnly@")}${var.subdomain}"
  }
}

output "name_servers" {
  value = module.custom_domain.name_servers
}