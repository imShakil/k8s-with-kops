variable "env" {
  type = string
}

variable "org_prefix" {
  type = string
}

variable "repositories" {
  type        = list(string)
  description = "List of repository names to create"
  default     = ["frontend", "backend", "database"]
}

variable "region" {
  default = "us-east-1"
}

variable "prefix" {
  default = "kops-idp"
}

variable "cluster_name" {
  default = "kops-cluster"
}
