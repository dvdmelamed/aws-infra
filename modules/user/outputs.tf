output "summary" {
  value = {
    name              = var.name
    password          = var.has_console_access ? aws_iam_user_login_profile.this[0].encrypted_password : ""
    access_key_id     = aws_iam_access_key.this.id
    secret_access_key = aws_iam_access_key.this.encrypted_secret
  }
}
