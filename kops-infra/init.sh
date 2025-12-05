#!/bin/bash

# Auto-read from kops-init outputs
cd ../kops-init
BUCKET=$(terraform output -raw kops_state_bucket 2>/dev/null)
REGION=$(terraform output -raw region 2>/dev/null)
cd ../kops-infra

if [ -z "$BUCKET" ] || [ -z "$REGION" ]; then
    echo "Error: Run 'terraform apply' in kops-init/ first"
    exit 1
fi

echo "Auto-detected: bucket=$BUCKET, region=$REGION"

terraform init \
  -backend-config="bucket=$BUCKET" \
  -backend-config="key=infra/kops-terraform.tfstate" \
  -backend-config="region=$REGION"