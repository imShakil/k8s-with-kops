variable "env" {
  type    = string
  default = "dev"
}

variable "prefix" {
  default = "k8s"
}

variable "repositories" {
  type        = list(string)
  description = "List of repository names to create"
  default     = ["frontend", "backend", "database"]
}

variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "kops-cluster"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "kops-admin-key"
}

variable "allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
