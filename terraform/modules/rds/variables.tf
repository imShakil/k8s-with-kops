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

variable "priv_sg_id" {
  type = string
  description = "list security security groups in for private subnet(s) "
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