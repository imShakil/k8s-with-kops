variable "region" {
  default = "us-east-1"
}

variable "prefix" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "k8s"
}

variable "vpc_id" {
  description = "ID of the VPC where the EC2 instance will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "ID of the public subnet to place the EC2 instance in"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "SSH key pair name for EC2 access"
  type        = string
}

variable "allowed_cidrs" {
  description = "List of CIDRs allowed to access the instance via SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
