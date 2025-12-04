variable "prefix" {
  default = "k8s"
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "public_subnets" {
  type    = list(any)
  default = []
}

variable "private_subnets" {
  type    = list(any)
  default = []
}

variable "subnet_size" {
  default     = 2
  description = "Number of subnets to create (public and private)"
}
