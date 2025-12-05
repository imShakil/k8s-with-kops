#!/bin/bash

set -euo pipefail

# Get parameters
CLUSTER_NAME="${1:-${CLUSTER_NAME:-}}"
KOPS_STATE_STORE="${2:-${KOPS_STATE_STORE:-}}"

# Validate parameters
if [ -z "$CLUSTER_NAME" ] || [ -z "$KOPS_STATE_STORE" ]; then
    echo "Usage: $0 <cluster-name> <state-store>"
    echo "  or set CLUSTER_NAME and KOPS_STATE_STORE env vars"
    echo "Example: $0 my-cluster.k8s.local my-kops-state"
    exit 1
fi

echo "Destroying cluster: $CLUSTER_NAME"
echo "State store: s3://$KOPS_STATE_STORE"

# Confirm destruction
read -p "Are you sure you want to destroy this cluster? (yes/no): " confirm
[ "$confirm" != "yes" ] && { echo "Aborted"; exit 0; }

# Delete kops cluster first
echo "Deleting kops cluster..."
kops delete cluster --name="$CLUSTER_NAME" --state="s3://$KOPS_STATE_STORE" --yes || echo "WARNING: Cluster deletion failed"

# Destroy kops infrastructure
if [ -d "../kops-infra" ]; then
    echo "Destroying kops infrastructure..."
    cd ../kops-infra
    terraform init -input=false
    terraform destroy -auto-approve || echo "WARNING: Infrastructure destroy failed"
    cd - > /dev/null
fi

# Clean S3 state store
echo "Cleaning S3 state store..."
aws s3 rm "s3://$KOPS_STATE_STORE" --recursive 2>/dev/null || echo "WARNING: S3 cleanup failed"

# Destroy kops-init infrastructure
if [ -d "../kops-init" ]; then
    echo "Destroying kops-init infrastructure..."
    cd ../kops-init
    terraform init -input=false
    terraform destroy -auto-approve || echo "WARNING: Init infrastructure destroy failed"
    cd - > /dev/null
fi

echo "Cluster destruction completed"
