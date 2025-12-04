variable "repositories" {
  type    = list(string)
  default = ["frontend", "backend", "database"]
}

variable "env" {
  type = string
}

variable "prefix" {
  type = string
}
