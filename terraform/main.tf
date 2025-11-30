# ------------------------------
# ECR Repositories
# ------------------------------
module "ecr" {
  source     = "./modules/ecr"
  env        = var.env
  org_prefix = var.org_prefix
  repositories = var.repositories
}
  
module "iam" {
  source = "./modules/iam"
}
