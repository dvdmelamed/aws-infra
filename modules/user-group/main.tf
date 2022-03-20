resource "aws_iam_group" "this" {
  name = var.group_name
}

resource "aws_iam_policy" "assume_role" {
  name   = "${var.group_name}AssumeRole"
  path = "/"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": var.assume_role_arns
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "assume_role" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.assume_role.arn
}
