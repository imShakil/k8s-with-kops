output "kops_init" {
  description = "Kops initialization infrastructure outputs"
  value = {
    cluster_name      = var.cluster_name
    state_bucket      = module.s3.bucket_name
  }
}
