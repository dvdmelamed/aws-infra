module "aws_user" {
  for_each = local.users
  source = "./modules/user"
  name = each.value["name"]
  pgp_key = each.value["pgp_key"]
  has_console_access = each.value["has_console_access"]
  groups = each.value["groups"]

  providers = {
    aws = aws.users
  }
}
