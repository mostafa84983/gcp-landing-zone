variable "project_prefix" {
  description = "Prefix for project IDs"
  type        = string
  default     = "lz"
}

variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "billing_account_id" {
  description = "GCP Billing Account ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "admin_email" {
  description = "Email for admin user"
  type        = string
}

variable "tf_state_bucket" {
  description = "GCS bucket for Terraform state"
  type        = string
}

variable "log_bucket" {
  description = "GCS bucket for centralized logs"
  type        = string
}