#!/bin/bash

set -euo pipefail

# Default configuration
KOPS_VERSION="latest"
KUBECTL_VERSION="latest"
TERRAFORM_VERSION="latest"

LOG_FILE="$HOME/kops/prepare-vm.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install Kubernetes tools with specified or latest versions.

Options:
  --kops-version=VERSION       Set kOps version (default: latest)
  --kubectl-version=VERSION    Set kubectl version (default: latest)
  --terraform-version=VERSION  Set Terraform version (default: latest)
  -h, --help                   Show this help message

Examples:
  $0                                    # Install all latest versions
  $0 --kops-version=v1.28.0             # Install kOps v1.28.0, others latest
  $0 --kops-version=v1.28.0 --kubectl-version=v1.29.0
  $0 --terraform-version=1.6.0          # Specific Terraform, others latest
  $0 --kops-version=latest --kubectl-version=v1.29.0 --terraform-version=1.6.0

EOF
    exit 0
}

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --kops-version=*)
            KOPS_VERSION="${arg#*=}"
            ;;
        --kubectl-version=*)
            KUBECTL_VERSION="${arg#*=}"
            ;;
        --terraform-version=*)
            TERRAFORM_VERSION="${arg#*=}"
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            echo "Unknown option: $arg"
            show_usage
            ;;
    esac
done

command_exists() { command -v "$1" >/dev/null 2>&1; }

detect_platform() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)
    [[ "$arch" == "x86_64" ]] && arch="amd64"
    [[ "$arch" == "aarch64" ]] && arch="arm64"
    echo "${os}-${arch}"
}

get_latest_version() {
    local url=$1
    curl -fsSL "$url" | jq -r '.tag_name // .version'
}

install_jq() {
    command_exists jq && return
    log "Installing jq..."
    if command_exists apt-get; then
        sudo apt-get update -qq && sudo apt-get install -y jq curl unzip
    elif command_exists yum; then
        sudo yum install -y jq curl unzip
    elif command_exists brew; then
        brew install jq
    fi
}

install_aws_cli() {
    command_exists aws && return
    log "Installing AWS CLI..."
    local platform=$(detect_platform)
    if [[ "$platform" == linux-* ]]; then
        local arch="x86_64"
        [[ "$platform" == *arm64 ]] && arch="aarch64"
        curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip" -o awscli.zip
        unzip -q awscli.zip && sudo ./aws/install && rm -rf aws awscli.zip
    elif [[ "$platform" == darwin-* ]]; then
        curl -sL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o awscli.pkg
        sudo installer -pkg awscli.pkg -target / && rm awscli.pkg
    fi
}

install_kops() {
    command_exists kops && return
    local version="$KOPS_VERSION"
    [[ "$version" == "latest" ]] && version=$(get_latest_version "https://api.github.com/repos/kubernetes/kops/releases/latest")
    log "Installing kOps ${version}..."
    curl -fsSL "https://github.com/kubernetes/kops/releases/download/${version}/kops-$(detect_platform)" -o kops
    chmod +x kops && sudo mv kops /usr/local/bin/
}

install_kubectl() {
    command_exists kubectl && return
    local version="$KUBECTL_VERSION"
    [[ "$version" == "latest" ]] && version=$(curl -sL https://dl.k8s.io/release/stable.txt)
    log "Installing kubectl ${version}..."
    local platform=$(detect_platform)
    curl -fsSL "https://dl.k8s.io/release/${version}/bin/${platform//-//}/kubectl" -o kubectl
    chmod +x kubectl && sudo mv kubectl /usr/local/bin/
}

install_terraform() {
    command_exists terraform && return
    local version="$TERRAFORM_VERSION"
    [[ "$version" == "latest" ]] && version=$(get_latest_version "https://api.releases.hashicorp.com/v1/releases/terraform/latest")
    log "Installing Terraform ${version}..."
    curl -fsSL "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_$(detect_platform).zip" -o terraform.zip
    unzip -q terraform.zip && chmod +x terraform && sudo mv terraform /usr/local/bin/ && rm terraform.zip
}

# Main
log "Requested versions: kOps=$KOPS_VERSION, kubectl=$KUBECTL_VERSION, Terraform=$TERRAFORM_VERSION"
log "Platform: $(detect_platform)"
log "Updating system packages..."

sudo apt-get update -y && sudo apt upgrade -y
log "✓ System packages updated successfully!"

install_jq
install_aws_cli
install_kops
install_kubectl
install_terraform

log "✓ All tools installed successfully!"
log "  - kOps: $(kops version --short)"
log "  - kubectl: $(kubectl version --client --short 2>/dev/null || echo "installed")"
log "  - Terraform: $(terraform version -json | jq -r '.terraform_version')"
log "  - AWS CLI: $(aws --version)"
