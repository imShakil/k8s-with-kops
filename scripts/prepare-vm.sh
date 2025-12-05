#!/bin/bash

set -euo pipefail

# Setup logging
LOG_DIR="/var/log/kops"
LOG_FILE="$LOG_DIR/prepare-vm-$(date +%Y%m%d-%H%M%S).log"
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting VM preparation script"

# Tool versions
KOPS_VERSION="v1.34.1"
KUBECTL_VERSION="v1.34.2"
TERRAFORM_VERSION="1.14.1"

log "Tool versions:"
log "  KOPS_VERSION: $KOPS_VERSION"
log "  KUBECTL_VERSION: $KUBECTL_VERSION"
log "  TERRAFORM_VERSION: $TERRAFORM_VERSION"

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
        *) log "ERROR: Unsupported architecture: $arch"; exit 1 ;;
    esac
    
    echo "${os}-${arch}"
}

# Install jq
install_jq() {
    command_exists jq && { log "jq already installed"; return; }
    
    log "Installing jq..."
    if command_exists apt-get; then
        sudo apt-get update -qq 2>&1 | tee -a "$LOG_FILE" && sudo apt-get install -y jq curl unzip 2>&1 | tee -a "$LOG_FILE"
    elif command_exists yum; then
        sudo yum install -y jq curl unzip 2>&1 | tee -a "$LOG_FILE"
    elif command_exists brew; then
        brew install jq curl unzip 2>&1 | tee -a "$LOG_FILE"
    else
        log "ERROR: No supported package manager found"
        exit 1
    fi
    log "jq installation completed"
}

# Install AWS CLI
install_aws_cli() {
    command_exists aws && { log "AWS CLI already installed"; return; }
    
    log "Installing AWS CLI..."
    case "$(detect_platform)" in
        linux-*)
            curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 2>&1 | tee -a "$LOG_FILE"
            unzip -q awscliv2.zip 2>&1 | tee -a "$LOG_FILE" && sudo ./aws/install 2>&1 | tee -a "$LOG_FILE" && rm -rf aws awscliv2.zip
            ;;
        darwin-*)
            curl -sL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg" 2>&1 | tee -a "$LOG_FILE"
            sudo installer -pkg "AWSCLIV2.pkg" -target / 2>&1 | tee -a "$LOG_FILE" && rm AWSCLIV2.pkg
            ;;
    esac
    log "AWS CLI installation completed"
}

# Install kOps
install_kops() {
    command_exists kops && { log "kOps already installed"; return; }
    
    log "Installing kOps ${KOPS_VERSION}..."
    curl -sL "https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-$(detect_platform)" -o "kops" 2>&1 | tee -a "$LOG_FILE"
    chmod +x kops && sudo mv kops /usr/local/bin/ 2>&1 | tee -a "$LOG_FILE"
    log "kOps installation completed"
}

# Install kubectl
install_kubectl() {
    command_exists kubectl && { log "kubectl already installed"; return; }
    
    log "Installing kubectl ${KUBECTL_VERSION}..."
    curl -sL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/$(detect_platform)/kubectl" -o "kubectl" 2>&1 | tee -a "$LOG_FILE"
    chmod +x kubectl && sudo mv kubectl /usr/local/bin/ 2>&1 | tee -a "$LOG_FILE"
    log "kubectl installation completed"
}

# Install Terraform
install_terraform() {
    command_exists terraform && { log "Terraform already installed"; return; }
    
    log "Installing Terraform ${TERRAFORM_VERSION}..."
    curl -sL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_$(detect_platform).zip" -o "terraform.zip" 2>&1 | tee -a "$LOG_FILE"
    unzip -q terraform.zip 2>&1 | tee -a "$LOG_FILE" && chmod +x terraform && sudo mv terraform /usr/local/bin/ 2>&1 | tee -a "$LOG_FILE" && rm terraform.zip
    log "Terraform installation completed"
}

# Main execution
log "Installing tools for Kubernetes cluster setup...
log "Detected platform: $(detect_platform)"

install_jq
install_aws_cli
install_kops
install_kubectl
install_terraform

log "All installations completed successfully!"
log "VM preparation log file: $LOG_FILE"
