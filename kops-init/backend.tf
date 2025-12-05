terraform {
  backend "s3" {
    # Configure via backend config file or CLI
    # bucket = "your-tfstate-bucket"
    # key    = "infra/kops-terraform.tfstate"
    # region = "your-region"
  }
}
