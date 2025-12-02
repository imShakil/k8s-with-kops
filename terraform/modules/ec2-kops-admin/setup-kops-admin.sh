#!/bin/bash

# Exit on any error
set -e

# Update and install prerequisites
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y curl wget unzip git apt-transport-https ca-certificates gnupg lsb-release jq

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Install kops
KOPS_VERSION="v1.29.0"
curl -LO "https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64"
sudo install -o root -g root -m 0755 kops-linux-amd64 /usr/local/bin/kops
rm kops-linux-amd64

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Install Terraform (latest)
TERRAFORM_VERSION="1.6.3"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Verify installations
echo "Verifying installations..."
kubectl version --client
kops version
aws --version
terraform version

echo "Kops admin setup complete!"
