# Simple GCP Landing Zone with Terraform

A Terraform-based Google Cloud Platform (GCP) landing zone for creating a secure, scalable environment with management, production, and development projects, a Shared VPC, IAM roles, centralized logging, and a GitOps pipeline.

## Features

- **Projects**: Creates `mgmt`, `prod`, and `dev` projects under a GCP Organization.
- **Shared VPC**: Hosted in `mgmt` project, with `prod` and `dev` as service projects.
- **Networking**: VPC with a subnet and firewall rules for SSH (22), HTTP (80), HTTPS (443), and internal traffic.
- **IAM**: Least-privilege service account and admin roles.
- **Logging**: Exports logs to a GCS bucket created via bootstrap.
- **State Management**: Terraform state stored in a GCS bucket created via bootstrap.
- **GitOps**: GitHub Actions pipeline for automated deployment (`fmt`, `validate`, `plan`, `apply`).

## Directory Structure

- `bootstrap/`: Creates GCS buckets (state and logs) and service account.
- `main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`: Main configuration and variables.
- `modules/`: Reusable modules:
  - `project-factory`: Creates projects and enables APIs.
  - `networking`: Configures Shared VPC and firewall rules.
  - `iam`: Sets up service accounts and roles.
  - `monitoring`: Configures logging sinks.
- `.github/workflows/terraform.yml`: GitHub Actions pipeline.

## Setup

1. **Prerequisites**:
   - GCP account with billing account (free tier: $300 credits).
   - GCP Organization (requires verified domain).
   - Terraform v1.5.0+ and gcloud CLI installed.
   - GitHub repository for CI/CD.
   - Bootstrap project (e.g., `lz-bootstrap-470415`).
   - Service account with `roles/resourcemanager.projectCreator` and `roles/billing.user` at organization/billing account level.

2. **Bootstrap**:
   ```bash
   cd bootstrap
   terraform init
   terraform apply
   ```
   Update `bootstrap/terraform.tfvars` with `bootstrap_project_id`, `region`, `tf_state_bucket`, `log_bucket`. Save `tf_admin_service_account_key` (base64-encoded).

3. **Main Configuration**:
   - Update `terraform.tfvars` with `org_id`, `billing_account_id`, `admin_email`, `tf_state_bucket`, `log_bucket`.
   - Run:
     ```bash
     cd ..
     terraform init -backend-config="bucket=lz-tf-state-123"
     terraform apply
     ```
     Use bootstrapped bucked for `-backend-config`

4. **GitHub Actions**:
   - Add secrets: `GCP_SA_KEY` (base64-encoded), `PROJECT_PREFIX`, `ORG_ID`, `BILLING_ACCOUNT_ID`, `ADMIN_EMAIL`, `TF_STATE_BUCKET`, `LOG_BUCKET`.
   - Pipeline decodes `GCP_SA_KEY`, runs Terraform commands in `gcp-landing-zone/`.

## Notes

- Testing limited due to domain verification issues; `org_id` is a placeholder.
- Production requires valid `org_id` and organization-level IAM roles.