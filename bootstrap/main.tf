# Configure the Google Cloud Provider
provider "google" {
  project = var.bootstrap_project_id
  region  = var.default_region
}

# Create bucket for Terraform state
resource "google_storage_bucket" "terraform_state" {
  name     = var.state_bucket_name
  location = var.bucket_location
  project  = var.bootstrap_project_id
  
  # Enable uniform bucket-level access
  # https://cloud.google.com/storage/docs/uniform-bucket-level-access
  uniform_bucket_level_access = true
  
  # Enable versioning
  # https://cloud.google.com/storage/docs/object-versioning
  versioning {
    enabled = true
  }
  
  # Delete old versions after 30 days
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
  
  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
}

# Enable required APIs for the bootstrap project
# https://cloud.google.com/apis/docs/overview
resource "google_project_service" "bootstrap_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com"
  ])
  
  project = var.bootstrap_project_id
  service = each.value
  
  # Disable the service on destroy
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service#disable_on_destroy
  disable_on_destroy = false
}

