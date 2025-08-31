variable "bootstrap_project_id" {
  description = "Project ID for bootstrap resources"
  type        = string
}

variable "state_bucket_name" {
  description = "Name for the Terraform state bucket"
  type        = string
}

variable "default_region" {
  description = "Default region for resources"
  type        = string
  default     = "us-central1"
}

variable "bucket_location" {
  description = "Location for the state bucket"
  type        = string
  default     = "US"
}
