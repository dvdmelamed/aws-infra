resource "aws_organizations_account" "account" {
  name      = var.account_name
  email     = var.account_owner
  parent_id = var.organization_unit_id
  role_name = "Admin"
}

module "custom_domain" {
  source    = "../domain"
  zone_name = "${var.subdomain}.${var.domain}"

  providers = {
    aws = aws.custom
  }
}

module "iam_role" {
  for_each = var.roles
  source         = "../iam-role"
  name           = each.value["role_name"]
  trusted_entity = "arn:aws:iam::${var.trusted_account_id}:root"
  policy_access = each.value["policy_name"]

  providers = {
    aws = aws.custom
  }
}

#module "github_oidc" {
#  source               = "../github-oidc"
#  client_id_list       = var.github_organisations
#  full_repository_name = var.full_repository_name
#  name                 = "GithubAction${title(var.subdomain)}Role"
#}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.account.id}:role/Admin"
  }

  alias  = "custom"
  region = "us-east-1"
}