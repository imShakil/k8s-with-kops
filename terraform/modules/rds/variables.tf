variable "vpc_id" {
  description = "The VPC ID where RDS will be deployed"
  type        = string
}

variable "db_name" {
  type = string
  description = "database name"
}

variable "db_user" {
    type = string
    description = "database username" 
}

variable "db_pass" {
  type = string
  description = "database password"
}

variable "env" {
  type = string
  description = "environment"
}

variable "prefix" {
  type = string
  description = "prefix for naming"
}

variable "region" {
  type = string
  description = "AWS region"
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "kops_sg_id" {
  description = "Security group ID of Kops nodes allowed to access RDS"
  type        = string
}