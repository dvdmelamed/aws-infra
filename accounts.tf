resource "aws_organizations_organization" "organization" {
  feature_set = "ALL"
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]
}

resource "aws_organizations_organizational_unit" "users" {
  name      = "Users"
  parent_id = aws_organizations_organization.organization.roots[0].id
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = aws_organizations_organization.organization.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.organization.roots[0].id
}

resource "aws_organizations_account" "users" {
  name      = local.accounts["users"]["name"]
  email     = local.accounts["users"]["owner"]
  parent_id = aws_organizations_organizational_unit.users.id
  role_name = "Admin"
}

resource "aws_organizations_account" "dev" {
  name      = local.accounts["dev"]["name"]
  email     = local.accounts["dev"]["owner"]
  parent_id = aws_organizations_organizational_unit.sandbox.id
  role_name = "Admin"
}

resource "aws_organizations_account" "staging" {
  name      = local.accounts["staging"]["name"]
  email     = local.accounts["staging"]["owner"]
  parent_id = aws_organizations_organizational_unit.workloads.id
  role_name = "Admin"
}

resource "aws_organizations_account" "production" {
  name      = local.accounts["production"]["name"]
  email     = local.accounts["production"]["owner"]
  parent_id = aws_organizations_organizational_unit.workloads.id
  role_name = "Admin"
}
