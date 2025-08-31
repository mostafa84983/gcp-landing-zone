provider "google" {
  project = var.bootstrap_project_id
  region  = var.default_region
}

# Create bucket for Terraform state
resource "google_storage_bucket" "terraform_state" {
  name     = var.state_bucket_name
  location = var.bucket_location
  project  = var.bootstrap_project_id
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }
  
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
resource "google_project_service" "bootstrap_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com"
  ])
  
  project = var.bootstrap_project_id
  service = each.value
  
  disable_on_destroy = false
}
