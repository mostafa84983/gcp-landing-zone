provider "google" {
  region = var.region
}

# Configure GCS backend using bootstrap bucket
terraform {
  backend "gcs" {
    prefix = "terraform/state"
  }
}

# Create management project
module "mgmt_project" {
  source            = "./modules/project-factory"
  project_id        = "${var.project_prefix}-mgmt"
  project_name      = "Management Project"
  org_id            = var.org_id
  billing_account   = var.billing_account_id
  enable_apis       = [
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "iam.googleapis.com"
  ]
}

# Create production project
module "prod_project" {
  source            = "./modules/project-factory"
  project_id        = "${var.project_prefix}-prod"
  project_name      = "Production Project"
  org_id            = var.org_id
  billing_account   = var.billing_account_id
  enable_apis       = [
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ]
}

# Create development project
module "dev_project" {
  source            = "./modules/project-factory"
  project_id        = "${var.project_prefix}-dev"
  project_name      = "Development Project"
  org_id            = var.org_id
  billing_account   = var.billing_account_id
  enable_apis       = [
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

# Configure Shared VPC and networking with updated firewall rules
module "networking" {
  source            = "./modules/networking"
  host_project_id   = module.mgmt_project.project_id
  service_project_ids = [
    module.prod_project.project_id,
    module.dev_project.project_id
  ]
  vpc_name          = "lz-shared-vpc"
  subnet_region     = var.region
  subnet_cidr       = "10.0.0.0/24"
}

# Configure IAM roles
module "iam" {
  source            = "./modules/iam"
  project_id        = module.mgmt_project.project_id
  service_account_id = "lz-admin-sa"
  admin_email       = var.admin_email
}

# Configure logging sink
module "monitoring" {
  source            = "./modules/monitoring"
  project_id        = module.mgmt_project.project_id
  sink_destination  = "storage.googleapis.com/${var.log_bucket}"
}