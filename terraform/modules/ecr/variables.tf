variable "repositories" {
  type    = list(string)
  default = ["frontend", "backend", "database"]
}

variable "env" {
  type = string 
}

variable "org_prefix" {
  type = string 
}
