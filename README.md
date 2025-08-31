# Simple GCP Landing Zone with Terraform

A Terraform-based Google Cloud Platform (GCP) landing zone for creating a secure, scalable environment with management, development project, VPCs, IAM roles, centralized logging, and a GitOps pipeline.

## Features

- **Projects**: Creates `mgmt`, and `dev` projects under a GCP Organization.
- **Shared VPC**: Hosted in `mgmt` project, with `dev` as service project.
- **Networking**: VPC with a subnet and firewall rules for SSH (22), HTTP (80), HTTPS (443), and internal traffic.
- **IAM**: Least-privilege service account and admin roles.
- **Logging**: Exports logs to a GCS bucket created via bootstrap.
- **State Management**: Terraform state stored in a GCS bucket created via bootstrap.
- **GitOps**: GitHub Actions pipeline for automated deployment (`validate`, `plan`, `apply`).

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

### 1. **Prerequisites**:
- GCP account with billing account (free tier: $300 credits).
- Terraform v1.5.0+ and gcloud CLI installed.
- GitHub repository for CI/CD.
- Bootstrap project (e.g., `lz-bootstrap-470415`).
- Service account with `roles/resourcemanager.projectCreator` and `roles/billing.user` at organization/billing account level.

### 2. **Bootstrap**:
   ```bash
   cd bootstrap
   terraform init
   terraform apply
   ```
   Update `bootstrap/terraform.tfvars` with `bootstrap_project_id`, and `state_bucket_name`. Note the created bucket (`state_bucket_name`)

### 3. **Main Configuration**:
- Update `terraform.tfvars` with `mgmt_project_id`, `billing_account_id`, and `dev_project_id`.
- Run:
     ```bash
     cd ..
     terraform init -backend-config="bucket=lz-tf-state-123" # state_bucket_name from bootstrap
     terraform apply
     ```

### 4. **GitHub Actions**:
- Add secrets: `GCP_SA_KEY`, `DEV_PROJECT_ID`, `MGMT_PROJECT_ID`, `BILLING_ACCOUNT_ID`, `STATE_BUCKET_NAME`.
- Read the next section on how to get a `GCP-SA-Key`.

#### Getting the GCP Service Account Key (GCP_SA_KEY)

The GCP_SA_KEY is a JSON service account key that allows GitHub Actions to authenticate with Google Cloud Platform. Follow these steps to create and configure it:
##### Prerequisites
- You must have completed the bootstrap setup (created your projects)
- You need Owner or Service Account Admin permissions on your projects
- gcloud CLI installed and authenticated

#### Step 1: Create the Service Account

```bash
# Create service account in management project
gcloud iam service-accounts create github-actions \
    --display-name="GitHub Actions SA" \
    --project=YOUR-MGMT-PROJECT-ID
```
#### Step 2: Grant Required Permissions

The service account needs permissions across all your projects:

```bash
# Replace with your actual project IDs
BOOTSTRAP_PROJECT="your-bootstrap-project-id"
MGMT_PROJECT="your-mgmt-project-id" 
DEV_PROJECT="your-dev-project-id"

# Grant permissions on bootstrap project (for Terraform state)
gcloud projects add-iam-policy-binding $BOOTSTRAP_PROJECT \
    --member="serviceAccount:github-actions@${MGMT_PROJECT}.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $BOOTSTRAP_PROJECT \
    --member="serviceAccount:github-actions@${MGMT_PROJECT}.iam.gserviceaccount.com" \
    --role="roles/serviceusage.serviceUsageAdmin"

# Grant permissions on management project
gcloud projects add-iam-policy-binding $MGMT_PROJECT \
    --member="serviceAccount:github-actions@${MGMT_PROJECT}.iam.gserviceaccount.com" \
    --role="roles/owner"

# Grant permissions on development project
gcloud projects add-iam-policy-binding $DEV_PROJECT \
    --member="serviceAccount:github-actions@${MGMT_PROJECT}.iam.gserviceaccount.com" \
    --role="roles/owner"
```
#### Step 3: Create and Download the Key

```bash
# Create JSON key file
gcloud iam service-accounts keys create github-actions-key.json \
    --iam-account=github-actions@YOUR-MGMT-PROJECT-ID.iam.gserviceaccount.com \
    --project=YOUR-MGMT-PROJECT-ID
```
#### Step 4: Add Key to GitHub Secrets

Copy the entire JSON content:

```bash
cat github-actions-key.json
```
Go to your GitHub repository:

- Navigate to Settings → Secrets and variables → Actions
- Create new repository secret:
- Click "New repository secret" `Name: GCP_SA_KEY`
- Value: Paste the entire JSON content from step 1
- Click "Add secret"

#### Step 5: Clean Up Local Key File

```bash
rm github-actions-key.json
```
#### Step 6: Verify Setup

Test that the service account has proper access:

```bash
# Activate the service account (temporarily for testing)
gcloud auth activate-service-account \
    --key-file=github-actions-key.json

# Test access to your projects
gcloud projects list --filter="projectId:your-prefix-*"

# Test bucket access
gsutil ls gs://your-terraform-state-bucket

# Switch back to your user account
gcloud auth login
```
#### Security Notes

⚠️ Important Security Practices:

    Never commit the JSON key file to your repository

    Delete the local key file after adding to GitHub Secrets

    Use least-privilege permissions (only what's needed)

    Rotate keys periodically in production environments

    Monitor service account usage in GCP Console


## Notes
- Testing limited due to project leve (no organization, domain, folder, etc.).
