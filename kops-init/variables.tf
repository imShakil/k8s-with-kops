variable "env" {
  type    = string
  default = "dev"
}

variable "prefix" {
  default = "kops"
}

variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "demo.k8s.local"
}

variable "kops_node_count" {
  default = 2
}

variable "kops_node_size" {
  default = "t2.micro"
}

variable "kops_master_size" {
  default = "t2.medium"
}
