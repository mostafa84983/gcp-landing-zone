variable "project_name" {
  description = "Project display name"
  type        = string
}

variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "services" {
  description = "APIs to enable"
  type        = list(string)
  default     = []
}
