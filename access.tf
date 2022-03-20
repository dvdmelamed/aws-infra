module "role_dev" {
  for_each = local.roles
  source         = "./modules/iam-role"
  name           = each.value["role_name"]
  trusted_entity = "arn:aws:iam::${aws_organizations_account.users.id}:root"
  policy_access = each.value["policy_name"]

  providers = {
    aws = aws.dev
  }
}

module "role_staging" {
  for_each = local.roles
  source         = "./modules/iam-role"
  name           = each.value["role_name"]
  trusted_entity = "arn:aws:iam::${aws_organizations_account.users.id}:root"
  policy_access = each.value["policy_name"]

  providers = {
    aws = aws.staging
  }
}

module "role_production" {
  for_each = local.roles
  source         = "./modules/iam-role"
  name           = each.value["role_name"]
  trusted_entity = "arn:aws:iam::${aws_organizations_account.users.id}:root"
  policy_access = each.value["policy_name"]

  providers = {
    aws = aws.production
  }
}

module "developer_group" {
  source     = "./modules/user-group"
  group_name = "Developer"

  assume_role_arns = [
    module.role_dev["admin"].role_arn,
    module.role_dev["readonly"].role_arn,
    module.role_staging["readonly"].role_arn,
    module.role_production["readonly"].role_arn,
  ]

  providers = {
    aws = aws.users
  }
}

module "super_admin_group" {
  source     = "./modules/user-group"
  group_name = "SuperAdmin"

  assume_role_arns = [
    module.role_dev["admin"].role_arn,
    module.role_dev["readonly"].role_arn,
    module.role_staging["admin"].role_arn,
    module.role_staging["readonly"].role_arn,
    module.role_production["admin"].role_arn,
    module.role_production["readonly"].role_arn,
  ]

  providers = {
    aws = aws.users
  }
}

# To enable users to self manage vMFA and creds
module "self-managing-group-user" {
  source = "./modules/self-managing-group"

  providers = {
    aws = aws.users
  }
}

