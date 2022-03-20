resource "aws_iam_openid_connect_provider" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = var.client_id_list

  thumbprint_list = ["15e29108718111e59b3dad31954647e3c344a231"]
}

resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = data.template_file.assume_role.rendered
}

data "template_file" "assume_role" {
  template = file("${path.module}/assume_role.tpl")

  vars = {
    trusted_entity       = aws_iam_openid_connect_provider.github_oidc.arn
    full_repository_name = var.full_repository_name
  }
}

resource "aws_iam_role_policy_attachment" "iam_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "administrator_access" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.this.name
}