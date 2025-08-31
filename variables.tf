variable "billing_account_id" {
  description = "Billing account ID"
  type        = string
}

variable "mgmt_project_id" {
  description = "Management project ID"
  type        = string
}

variable "dev_project_id" {
  description = "Development project ID"
  type        = string
}

variable "default_region" {
  description = "Default region"
  type        = string
  default     = "us-central1"
}

# Keep these for compatibility even if unused
variable "network_name" {
  description = "Network name"
  type        = string
  default     = "vpc"
}

variable "subnets" {
  description = "Subnet configuration"
  type        = any
  default     = {}
}
