output "iam" {
  value     = module.iam.kops_admin_credentials
  sensitive = true
}

