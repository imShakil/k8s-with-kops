output "all_ecr_urls" {
  value = module.ecr.ecr_repository_urls
}
  
output "iam" {
  value     = module.iam.kops_admin_credentials
  sensitive = true
}

