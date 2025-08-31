# Configure the Google Cloud Provider
provider "google" {
  region = var.default_region
}

# Configure Terraform to store state in GCS
terraform {
  backend "gcs" {
    prefix = "terraform/state"
  }
}

# Create management project
module "mgmt_project" {
  source = "./modules/project-factory"
  
  # Project name
  project_name    = "Management"
  
  # Project ID
  project_id      = var.mgmt_project_id
  
  # Billing account ID
  billing_account = var.billing_account_id
  
  # Services to enable
  services = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "storage.googleapis.com"
  ]
}

# Create development project
module "dev_project" {
  source = "./modules/project-factory"
  
  # Project name
  project_name    = "Development"
  
  # Project ID
  project_id      = var.dev_project_id
  
  # Billing account ID
  billing_account = var.billing_account_id
  
  # Services to enable
  services = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com"
  ]
}

# Create networking
module "networking" {
  source = "./modules/networking"
  
  # Host project ID
  host_project_id  = module.mgmt_project.project_id
  
  # Service projects
  service_projects = [module.dev_project.project_id]
  
  # Dependencies
  depends_on = [module.mgmt_project, module.dev_project]
}

# Create IAM
module "iam" {
  source = "./modules/iam"
  
  # Management project ID
  mgmt_project_id = module.mgmt_project.project_id
  
  # Development project ID
  dev_project_id  = module.dev_project.project_id
  
  # Dependencies
  depends_on = [module.mgmt_project, module.dev_project]
}

# Create monitoring
module "monitoring" {
  source = "./modules/monitoring"
  
  # Management project ID
  mgmt_project_id = module.mgmt_project.project_id
  
  # Development project ID
  dev_project_id  = module.dev_project.project_id
  
  # Dependencies
  depends_on = [module.mgmt_project, module.dev_project]
}
