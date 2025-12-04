output "kops_cluster_info" {
  value = {
    name        = var.cluster_name
    s3_bucket   = "s3://${module.kops_state_store.bucket_name}"
    kops_zones  = local.kops_zones
    iam_profile = module.iam.kops_admin_credentials.user_name
  }
  sensitive = true
}
