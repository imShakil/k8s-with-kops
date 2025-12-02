variable "prefix" {
  type        = string
  default = "k8s"
}

variable "vpc_cidr" {
  type        = string
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
  type        = number
  default = 2
  description = "Number of subnets to create (public and private)"
}
