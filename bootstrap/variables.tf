variable "bootstrap_project_id" {
  description = "Project ID for bootstrap resources"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "tf_state_bucket" {
  description = "GCS bucket for Terraform state"
  type        = string
}

variable "log_bucket" {
  description = "GCS bucket for centralized logs"
  type        = string
}