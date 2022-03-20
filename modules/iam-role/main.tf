resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = data.template_file.trust_relationship.rendered
}

data "template_file" "trust_relationship" {
  template = file("${path.module}/trust_relationship.tpl")

  vars = {
    enforce_mfa = var.enforce_mfa
    trusted_entity = var.trusted_entity
  }
}

resource "aws_iam_role_policy_attachment" "access" {
  policy_arn = "arn:aws:iam::aws:policy/${var.policy_access}Access"
  role       = aws_iam_role.this.name
}
