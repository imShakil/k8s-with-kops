module "terraform_state_store" {
  source = "../../modules/s3"

  bucket_name = "idp-tfstate-${var.env}-${var.aws_region}"

  tags = {
    Environment = var.env
    Project     = "idp"
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }
}

module "kops_state_store" {
  source = "../../modules/s3"

  bucket_name = "idp-kops-state-${var.env}-${var.aws_region}"

  tags = {
    Environment = var.env
    Project     = "idp"
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }
}
