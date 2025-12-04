terraform {
  backend "s3" {
    bucket = "kops-kops-state-dev-ap-southeast-1"
    key    = "infra/kops-terraform.tfstate"
    region = "ap-southeast-1"
  }
}