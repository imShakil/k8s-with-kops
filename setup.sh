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

# Step 3: Create cluster (with confirmation)
echo ""
read -p "🔥 Create K8s cluster now? This will incur AWS costs. (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🏗️  Creating cluster..."
    terraform apply
    echo "✅ Cluster created! Run 'kops validate cluster' to check status"
else
    echo "⏸️  Skipped cluster creation. Run 'terraform apply' in kops-infra/ when ready"
fi
