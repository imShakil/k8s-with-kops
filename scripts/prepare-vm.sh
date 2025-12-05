#!/bin/bash

set -euo pipefail

# Tool versions
KOPS_VERSION="v1.34.1"
KUBECTL_VERSION="v1.34.2"
TERRAFORM_VERSION="1.14.1"

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect platform
detect_platform() {
    local os arch
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)
    
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
    esac
    
    echo "${os}-${arch}"
}

# Install jq
install_jq() {
    command_exists jq && { echo "jq already installed"; return; }
    
    echo "Installing jq..."
    if command_exists apt-get; then
        sudo apt-get update -qq && sudo apt-get install -y jq curl unzip
    elif command_exists yum; then
        sudo yum install -y jq curl unzip
    elif command_exists brew; then
        brew install jq curl unzip
    else
        echo "No supported package manager found" >&2; exit 1
    fi
}

# Install AWS CLI
install_aws_cli() {
    command_exists aws && { echo "AWS CLI already installed"; return; }
    
    echo "Installing AWS CLI..."
    case "$(detect_platform)" in
        linux-*)
            curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip -q awscliv2.zip && sudo ./aws/install && rm -rf aws awscliv2.zip
            ;;
        darwin-*)
            curl -sL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
            sudo installer -pkg "AWSCLIV2.pkg" -target / && rm AWSCLIV2.pkg
            ;;
    esac
}

# Install kOps
install_kops() {
    command_exists kops && { echo "kOps already installed"; return; }
    
    echo "Installing kOps ${KOPS_VERSION}..."
    curl -sL "https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-$(detect_platform)" -o "kops"
    chmod +x kops && sudo mv kops /usr/local/bin/
}

# Install kubectl
install_kubectl() {
    command_exists kubectl && { echo "kubectl already installed"; return; }
    
    echo "Installing kubectl ${KUBECTL_VERSION}..."
    curl -sL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/$(detect_platform)/kubectl" -o "kubectl"
    chmod +x kubectl && sudo mv kubectl /usr/local/bin/
}

# Install Terraform
install_terraform() {
    command_exists terraform && { echo "Terraform already installed"; return; }
    
    echo "Installing Terraform ${TERRAFORM_VERSION}..."
    curl -sL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_$(detect_platform).zip" -o "terraform.zip"
    unzip -q terraform.zip && chmod +x terraform && sudo mv terraform /usr/local/bin/ && rm terraform.zip
}

# Main execution
echo "Installing tools for Kubernetes cluster setup..."

install_jq
install_aws_cli
install_kops
install_kubectl
install_terraform

echo "Installation completed!"
