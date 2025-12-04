terraform {
  backend "s3" {
    # change bucket name
    bucket = "imshakil-bkt-tfstate"
    key    = "infra/kops-terraform.tfstate"
    region = "ap-southeast-1"
  }
}
