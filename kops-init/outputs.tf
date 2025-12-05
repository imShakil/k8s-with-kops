output "kops_init" {
  description = "Kops initialization infrastructure outputs"
  value = {
    cluster_name      = var.cluster_name
    state_bucket      = module.kops_state_store.bucket_name
  }
}
