output "kops_admin_user_info" {
  description = "KOPS admin IAM user non-sensitive information"
  value = {
    user_name   = aws_iam_user.kops_admin.name
    user_arn    = aws_iam_user.kops_admin.arn
    create_date = aws_iam_access_key.kops_admin_key.create_date
  }
}

output "kops_admin_credentials" {
  description = "KOPS admin IAM user sensitive credentials"
  value = {
    access_key_id        = aws_iam_access_key.kops_admin_key.id
    access_key_secret    = aws_iam_access_key.kops_admin_key.secret
    ses_smtp_password_v4 = aws_iam_access_key.kops_admin_key.ses_smtp_password_v4
  }
  sensitive = true
}
