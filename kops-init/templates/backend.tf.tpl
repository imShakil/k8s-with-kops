terraform {
  backend "s3" {
    bucket = "${bucket_name}"
    key    = "infra/kops-terraform.tfstate"
    region = "${region}"
  }
}