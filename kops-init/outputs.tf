output "kops_init" {
  description = "Kops initialization infrastructure outputs"
  value = {
    cluster_name  = var.cluster_name
    state_bucket  = module.kops_state_store.bucket_name
    iam_user_name = module.iam.kops_admin_user_info.user_name
    iam_user_arn  = module.iam.kops_admin_user_info.user_arn
  }
}
output "kops_admin_credentials" {
  value     = module.iam.kops_admin_credentials
  sensitive = true
}
