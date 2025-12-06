output "kops_init" {
  description = "Kops initialization infrastructure outputs"
  value = {
    cluster_name  = var.cluster_name
    state_bucket  = module.kops_state_store.bucket_name
    iam_user_name = module.iam.kops_admin_user_info.user_name
    iam_user_arn  = module.iam.kops_admin_user_info.user_arn
  }
}

output "export_variables" {
  description = "Environment variables to export - copy and paste to terminal"
  value = <<-EOT
export KOPS_STATE_STORE=s3://${module.kops_state_store.bucket_name}
export KOPS_CLUSTER_NAME=${var.cluster_name}
export AWS_PROFILE=${module.iam.kops_admin_user_info.user_name}

EOT
}

output "kops_admin_credentials" {
  value     = module.iam.kops_admin_credentials
  sensitive = true
}
