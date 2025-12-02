variable "vpc_cidr" {
  type        = string
  default = "10.10.0.0/16"
}

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

variable "db_name" {
  type        = string
  description = "database name"
}

variable "db_user" {
  type        = string
  description = "database username"
}

variable "db_pass" {
  type        = string
  description = "database password"
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

variable "subnet_size" {
  type        = number
  default = 2
  description = "Number of subnets to create (public and private)"
}