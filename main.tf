provider "google" {
  region = var.default_region
}

# Configure the Google Cloud Provider
terraform {
  backend "gcs" {
    prefix = "terraform/state"
  }
}

# Create management project
module "mgmt_project" {
  source = "./modules/project-factory"
  
  project_name    = "Management"
  project_id      = var.mgmt_project_id
  billing_account = var.billing_account_id
  
  services = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "storage.googleapis.com"
  ]
}

# Create dev project
module "dev_project" {
  source = "./modules/project-factory"
  
  project_name    = "Development"
  project_id      = var.dev_project_id
  billing_account = var.billing_account_id
  
  services = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com"
  ]
}

# Create networking
module "networking" {
  source = "./modules/networking"
  
  host_project_id  = module.mgmt_project.project_id
  service_projects = [module.dev_project.project_id]
  
  depends_on = [module.mgmt_project, module.dev_project]
}

# Create IAM
module "iam" {
  source = "./modules/iam"
  
  mgmt_project_id = module.mgmt_project.project_id
  dev_project_id  = module.dev_project.project_id
  
  depends_on = [module.mgmt_project, module.dev_project]
}

# Create monitoring
module "monitoring" {
  source = "./modules/monitoring"
  
  mgmt_project_id = module.mgmt_project.project_id
  dev_project_id  = module.dev_project.project_id
  
  depends_on = [module.mgmt_project, module.dev_project]
}