variable "env" {
  type = string
}

variable "org_prefix" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "repositories" {
  type        = list(string)
  description = "List of repository names to create"
  default     = ["frontend", "backend", "database"]
}