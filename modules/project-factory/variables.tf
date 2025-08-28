variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "org_id" {
  description = "Organization ID"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "enable_apis" {
  description = "List of APIs to enable"
  type        = list(string)
}