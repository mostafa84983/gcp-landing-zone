variable "host_project_id" {
  description = "Management project ID"
  type        = string
}

variable "service_projects" {
  description = "Service project IDs (dev only)"
  type        = list(string)
}

#  Unused but kept for compatibility
variable "network_name" {
  description = "Network name"
  type        = string
  default     = "vpc"
}

#  Unused but kept for compatibility
variable "subnets" {
  description = "Subnets config"
  type        = any
  default     = {}
}

variable "default_region" {
  description = "Default region"
  type        = string
  default     = "us-central1"
}