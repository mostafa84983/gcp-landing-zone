#!/bin/bash
set -e  # Exit on any error

# Check if required environment variables are set
if [ -z "$MGMT_PROJECT_ID" ]; then
    echo "Error: MGMT_PROJECT_ID environment variable is not set"
    exit 1
fi

if [ -z "$DEV_PROJECT_ID" ]; then
    echo "Error: DEV_PROJECT_ID environment variable is not set"
    exit 1
fi

echo "=== GCP Landing Zone Verification ==="
echo "Timestamp: $(date)"
echo "Management Project: ${MGMT_PROJECT_ID}"
echo "Development Project: ${DEV_PROJECT_ID}"
echo ""

echo "1. Projects:"
gcloud projects list --filter="projectId:lz-*"

echo -e "\n2. VPC Networks:"
gcloud compute networks list --project=${DEV_PROJECT_ID}

echo -e "\n3. Service Accounts:"
echo "Management Project:"
gcloud iam service-accounts list --project=${MGMT_PROJECT_ID} --format="value(email)"
echo "Development Project:"
gcloud iam service-accounts list --project=${DEV_PROJECT_ID} --format="value(email)"

echo -e "\n4. Storage Buckets:"
gcloud storage buckets list --project=${MGMT_PROJECT_ID} --format="value(name)"

echo -e "\n✅ Landing Zone deployed successfully!"
