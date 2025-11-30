# variable "environment" {
#   description = "Environment name (dev, stage, prod)"
#   type        = string
#   validation {
#     condition     = contains(["dev", "stage", "prod"], var.environment)
#     error_message = "Environment must be dev, stage, or prod."
#   }
# }

# variable "enable_mfa" {
#   description = "Enable MFA for IAM users"
#   type        = bool
#   default     = false
# }

variable "prefix" {
  default = "kops"
}
