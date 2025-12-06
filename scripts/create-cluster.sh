#!/bin/bash

set -euo pipefail

# Setup logging
LOG_DIR="$HOME/kops"
LOG_FILE="$LOG_DIR/create-cluster.log"
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Error handling function
error_exit() {
    log "ERROR: $1"
    exit 1
}

log "Starting cluster creation script"

# Use environment variables with defaults
CLUSTER_NAME="${CLUSTER_NAME:-demo.k8s.local}"
STATE_STORE="${KOPS_STATE_STORE:-}"
ZONES="${KOPS_ZONES:-}"
NODE_COUNT="${NODE_COUNT:-2}"
NODE_SIZE="${NODE_SIZE:-t3.small}"
MASTER_COUNT="${MASTER_COUNT:-1}"
MASTER_SIZE="${MASTER_SIZE:-t3.medium}"
TOPOLOGY="${TOPOLOGY:-public}"
KOPS_DIR="../kops-infra"
SSH_KEY_PATH="$HOME/.ssh/id_rsa"

log "Configuration loaded:"
log "  CLUSTER_NAME: $CLUSTER_NAME"
log "  STATE_STORE: $STATE_STORE"
log "  ZONES: $ZONES"
log "  NODE_COUNT: $NODE_COUNT"
log "  NODE_SIZE: $NODE_SIZE"
log "  MASTER_SIZE: $MASTER_SIZE"
log "  TOPOLOGY: $TOPOLOGY"

# Validate required environment variables
log "Validating environment variables..."
[ -z "$STATE_STORE" ] && error_exit "KOPS_STATE_STORE environment variable is required"
[ -z "$ZONES" ] && error_exit "KOPS_ZONES environment variable is required"
log "Environment variables validated successfully"

# Validate numeric node count
log "Validating node count..."
[[ ! "$NODE_COUNT" =~ ^[0-9]+$ ]] && error_exit "Node count must be a positive integer"
[ "$NODE_COUNT" -lt 1 ] && error_exit "Node count must be at least 1"
log "Node count validation passed"

# Check required tools
log "Checking required tools..."
command -v kops >/dev/null 2>&1 || error_exit "kops is not installed or not in PATH"
command -v aws >/dev/null 2>&1 || error_exit "aws CLI is not installed or not in PATH"
log "Required tools check passed"

# Validate AWS credentials
log "Validating AWS credentials..."
aws sts get-caller-identity >/dev/null 2>&1 || error_exit "AWS credentials not configured or invalid"
log "AWS credentials validated successfully"

# Check and generate SSH key if needed
log "Checking SSH key..."
if [ ! -f "$SSH_KEY_PATH" ]; then
    log "SSH key not found at $SSH_KEY_PATH, generating new key..."
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -C "kops-cluster-$CLUSTER_NAME" || error_exit "Failed to generate SSH key"
    log "SSH key generated at $SSH_KEY_PATH"
else
    log "Using existing SSH key at $SSH_KEY_PATH"
fi

# Detect topology and DNS mode based on cluster name
log "Detecting cluster configuration..."
if [[ "$CLUSTER_NAME" == *.k8s.local ]]; then
    DNS_MODE="gossip"
    DNS_ARGS="--dns=private"
else
    DNS_MODE="public"
    # Extract base domain from cluster name (e.g., demo.lab.mhosen.com -> lab.mhosen.com)
    BASE_DOMAIN=$(echo "$CLUSTER_NAME" | awk -F. '{print $(NF-2)"."$(NF-1)"."$NF}')
    DNS_ARGS="--dns-zone=$BASE_DOMAIN"
fi

log "Detected DNS mode: $DNS_MODE"
log "DNS configuration: $DNS_ARGS"

log "Creating cluster with kops: $CLUSTER_NAME"

# Check if cluster exists
log "Checking if cluster exists..."
if ! kops get cluster --name="$CLUSTER_NAME" --state="$STATE_STORE" >/dev/null 2>&1; then
    log "Creating new cluster..."
    kops_args=(
        --name="$CLUSTER_NAME"
        --state="$STATE_STORE"
        --zones="$ZONES"
        --topology="$TOPOLOGY"
        --node-count="$NODE_COUNT"
        --node-size="$NODE_SIZE"
        --control-plane-count="$MASTER_COUNT"
        --control-plane-size="$MASTER_SIZE"
        --networking=calico
        --ssh-public-key="$SSH_KEY_PATH.pub"
    )
    
    # Add DNS arguments (word splitting intentional)
    kops_args+=($DNS_ARGS)
    
    log "Running: kops create cluster ${kops_args[*]}"
    kops create cluster "${kops_args[@]}" 2>&1 | tee -a "$LOG_FILE" || error_exit "Failed to create cluster"
    log "Cluster creation completed successfully"
else
    log "Cluster already exists, skipping creation"
fi

log "Updating cluster configuration..."
kops update cluster \
    --name="$CLUSTER_NAME" \
    --state="$STATE_STORE" \
    --yes \
    --admin \
    --out "$KOPS_DIR" \
    --target terraform 2>&1 | tee -a "$LOG_FILE" || error_exit "Failed to update cluster"

log "Cluster configuration generated successfully in $KOPS_DIR"
log "Script completed successfully. Log file: $LOG_FILE"
