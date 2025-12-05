#!/bin/bash

echo "🚀 Setting up K8s cluster with Kops..."

# Step 1: Setup infrastructure
echo "📦 Creating infrastructure..."
cd kops-init/
terraform init && terraform apply -auto-approve

# Step 2: Setup cluster
echo "☸️  Initializing cluster..."
cd ../kops-infra/
./init.sh

echo "✅ Setup complete! Run 'terraform apply' in kops-infra/ to create cluster"
