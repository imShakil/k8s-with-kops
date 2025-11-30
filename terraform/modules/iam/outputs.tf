output "kops_admin_credentials" {
  description = "Complete KOPS admin IAM user credentials and details"
  value = {
    user_name            = aws_iam_user.kops_admin.name
    user_arn             = aws_iam_user.kops_admin.arn
    access_key_id        = aws_iam_access_key.kops_admin_key.id
    access_key_secret    = aws_iam_access_key.kops_admin_key.secret
    create_date          = aws_iam_access_key.kops_admin_key.create_date
    ses_smtp_password_v4 = aws_iam_access_key.kops_admin_key.ses_smtp_password_v4
  }
  sensitive = true
}