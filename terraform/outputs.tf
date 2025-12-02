output "all_ecr_urls" {
  value = module.ecr.ecr_repository_urls
}

output "iam" {
  value     = module.iam.kops_admin_credentials
  sensitive = true
}

output "vpc" {
  value = module.vpc.vpc_info
}

output "kops_admin_public_ip" {
  value = module.kops_admin.public_ip
}

