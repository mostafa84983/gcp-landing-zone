#!/bin/bash
echo "=== GCP Landing Zone Verification ==="
echo "1. Projects:"
gcloud projects list --filter="projectId:lz-*"

echo -e "\n2. VPC Networks:"
gcloud compute networks list --project=lz-dev-470416

echo -e "\n3. Service Accounts:"
gcloud iam service-accounts list --project=lz-mgmt-470415 --format="value(email)"
gcloud iam service-accounts list --project=lz-dev-470416 --format="value(email)"

echo -e "\n4. Storage Buckets:"
gcloud storage buckets list --project=lz-mgmt-470415 --format="value(name)"
