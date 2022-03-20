resource "aws_iam_group" "self_managing" {
  name = "SelfManaging"
}

resource "aws_iam_group_policy_attachment" "iam_read_only_access" {
  group      = aws_iam_group.self_managing.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "iam_self_manage_service_specific_credentials" {
  count      = var.has_console_access ? 1 : 0
  group      = aws_iam_group.self_managing.name
  policy_arn = "arn:aws:iam::aws:policy/IAMSelfManageServiceSpecificCredentials"
}

resource "aws_iam_group_policy_attachment" "iam_user_change_password" {
  count      = var.has_console_access ? 1 : 0
  group      = aws_iam_group.self_managing.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_policy" "self_manage_vmfa" {
  count  = var.has_console_access ? 1 : 0
  name   = "SelfManageVMFA"
  policy = file("${path.module}/self_manage_vmfa.json")
}

resource "aws_iam_group_policy_attachment" "self_manage_vmfa" {
  count      = var.has_console_access ? 1 : 0
  group      = aws_iam_group.self_managing.name
  policy_arn = aws_iam_policy.self_manage_vmfa[0].arn
}
