#!/bin/bash

set -euo pipefail

# Error handling function
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

CLUSTER_NAME="${CLUSTER_NAME:-}"
KOPS_STATE_STORE="${KOPS_STATE_STORE:-}"

# Validate required parameters
[ -z "$CLUSTER_NAME" ] && error_exit "Cluster name is required as first parameter"
[ -z "$KOPS_STATE_STORE" ] && error_exit "Kops state store is required as second parameter"

echo "This script will destroy the cluster and all resources associated with it."

echo "Destroying cluster infrastructure..."
cd ../kops-infra || error_exit "Failed to change to kops-infra directory"

# Initialize and destroy with Terraform
terraform init || error_exit "Terraform init failed"
if ! terraform destroy -auto-approve; then
    error_exit "Terraform destroy failed - S3 bucket will NOT be deleted for safety"
fi

echo "Deleting kops cluster..."
if ! kops delete cluster --name="${CLUSTER_NAME}" --state="s3://${KOPS_STATE_STORE}" --yes --admin; then
   error_exit "Failed to delete kops cluster"
fi

echo "Cleaning up S3 state store..."
aws s3 rm "s3://$KOPS_STATE_STORE" --recursive || echo "WARNING: Failed to empty S3 bucket"
aws s3 rb "s3://$KOPS_STATE_STORE" || echo "WARNING: Failed to delete S3 bucket"

echo "Cluster destruction completed."
