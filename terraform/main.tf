# ------------------------------
# ECR Repositories
# ------------------------------
module "ecr" {
  source       = "./modules/ecr"
  env          = var.env
  prefix       = var.prefix
  repositories = var.repositories
}

# ------------------------------
# IAM
# ------------------------------
module "iam" {
  source = "./modules/iam"
  prefix = "${var.prefix}-${var.env}"
}

# ------------------------------
# VPC
# ------------------------------
module "vpc" {
  source = "./modules/vpc"
  prefix = "${var.prefix}-${var.env}"
}

# ------------------------------
# S3 Bucket - Terraform State Store
# ------------------------------
module "terraform_state_store" {
  source      = "./modules/s3"
  bucket_name = "${var.prefix}-tfstate-${var.env}-${var.region}"

  tags = {
    Environment = var.env
    Project     = var.prefix
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }
}

# ------------------------------
# S3 Bucket - kOps State Store
# ------------------------------
module "kops_state_store" {
  source      = "./modules/s3"
  bucket_name = "${var.prefix}-kops-state-${var.env}-${var.region}"

  tags = {
    Environment = var.env
    Project     = var.prefix
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }
}

# ------------------------------
# EC2 - kOps Admin
# ------------------------------
module "kops_admin" {
  source        = "./modules/ec2-kops-admin"
  prefix        = var.prefix
  vpc_id        = module.vpc.vpc_info.vpc_id
  subnet_id     = module.vpc.vpc_info.public_subnet_ids[0]
  instance_type = var.instance_type
  key_name      = var.key_name
  allowed_cidrs = var.allowed_cidrs
}
