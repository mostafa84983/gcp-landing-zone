variable "host_project_id" {
  description = "Management project ID"
  type        = string
}

variable "service_projects" {
  description = "Service project IDs (dev only)"
  type        = list(string)
}

variable "network_name" {
  description = "Network name (unused but kept for compatibility)"
  type        = string
  default     = "vpc"
}

variable "subnets" {
  description = "Subnets config (unused but kept for compatibility)"
  type        = any
  default     = {}
}
