output "kops_state_bucket" {
  value = module.kops_state_store.bucket_name
}

output "region" {
  value = var.region
}

output "kops_backend_config" {
  value = "Run: cd ../kops-infra && terraform init -backend-config='bucket=${module.kops_state_store.bucket_name}' -backend-config='key=infra/kops-terraform.tfstate' -backend-config='region=${var.region}'"
}