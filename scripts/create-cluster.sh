#!/bin/bash

set -euo pipefail

# Error handling function
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Use environment variables with defaults
CLUSTER_NAME="${CLUSTER_NAME:-}"
STATE_STORE="${KOPS_STATE_STORE:-}"
ZONES="${KOPS_ZONES:-}"
NODE_COUNT="${NODE_COUNT:-2}"
NODE_SIZE="${NODE_SIZE:-t3.micro}"
MASTER_SIZE="${MASTER_SIZE:-t3.medium}"
KOPS_DIR="../kops-infra"
SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# Validate required environment variables
[ -z "$CLUSTER_NAME" ] && error_exit "CLUSTER_NAME environment variable is required"
[ -z "$STATE_STORE" ] && error_exit "KOPS_STATE_STORE environment variable is required"
[ -z "$ZONES" ] && error_exit "KOPS_ZONES environment variable is required"

# Validate numeric node count
[[ ! "$NODE_COUNT" =~ ^[0-9]+$ ]] && error_exit "Node count must be a positive integer"
[ "$NODE_COUNT" -lt 1 ] && error_exit "Node count must be at least 1"

# Check required tools
command -v kops >/dev/null 2>&1 || error_exit "kops is not installed or not in PATH"
command -v aws >/dev/null 2>&1 || error_exit "aws CLI is not installed or not in PATH"

# Validate AWS credentials
aws sts get-caller-identity >/dev/null 2>&1 || error_exit "AWS credentials not configured or invalid"

# Check and generate SSH key if needed
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "SSH key not found at $SSH_KEY_PATH, generating new key..."
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -C "kops-cluster-$CLUSTER_NAME" || error_exit "Failed to generate SSH key"
    echo "SSH key generated at $SSH_KEY_PATH"
else
    echo "Using existing SSH key at $SSH_KEY_PATH"
fi

# Detect topology automatically
if [[ "$CLUSTER_NAME" == *.k8s.local ]]; then
    TOPOLOGY="private"
    DNS_ZONE="none"
else
    TOPOLOGY="public"
    DNS_ZONE="$CLUSTER_NAME"
fi

echo "Detected topology: $TOPOLOGY"
echo "Using DNS zone: $DNS_ZONE"

echo "Creating cluster with kops: $CLUSTER_NAME"

# Check if cluster exists
if ! kops get cluster --name="$CLUSTER_NAME" --state="$STATE_STORE" >/dev/null 2>&1; then
    echo "Creating new cluster..."
    if [ "$TOPOLOGY" = "private" ]; then
        kops create cluster \
            --name="$CLUSTER_NAME" \
            --state="$STATE_STORE" \
            --zones="$ZONES" \
            --topology=private \
            --node-count="$NODE_COUNT" \
            --node-size="$NODE_SIZE" \
            --control-plane-size="$MASTER_SIZE" \
            --networking=calico \
            --ssh-public-key="$SSH_KEY_PATH.pub"
    else
        kops create cluster \
            --name="$CLUSTER_NAME" \
            --state="$STATE_STORE" \
            --zones="$ZONES" \
            --dns-zone="$DNS_ZONE" \
            --topology=public \
            --node-count="$NODE_COUNT" \
            --node-size="$NODE_SIZE" \
            --control-plane-size="$MASTER_SIZE" \
            --networking=calico \
            --ssh-public-key="$SSH_KEY_PATH.pub"
    fi
else
    echo "Cluster already exists, skipping creation"
fi

echo "Updating cluster configuration..."
kops update cluster \
    --name="$CLUSTER_NAME" \
    --state="$STATE_STORE" \
    --yes \
    --admin \
    --out "$KOPS_DIR" \
    --target terraform || error_exit "Failed to update cluster"

echo "Cluster configuration generated successfully in $KOPS_DIR"