variable "host_project_id" {
  description = "Host project ID for Shared VPC"
  type        = string
}

variable "service_project_ids" {
  description = "List of service project IDs"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "subnet_region" {
  description = "Region for the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
}