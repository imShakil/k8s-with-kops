variable "bucket_name" {
  description = "Name of S3 bucket."
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
