#!/bin/bash

set -euo pipefail

# Setup logging
LOG_DIR="$HOME/kops"
LOG_FILE="$LOG_DIR/destroy-cluster.log"
PROJECT_DIR="$HOME/k8s-with-kops"
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting cluster destruction script"

# check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    log "ERROR: Project directory $PROJECT_DIR does not exist"
    log "Make sure you have cloned the repository to $PROJECT_DIR"
    exit 1
fi

# Get parameters
KOPS_CLUSTER_NAME="${1:-${KOPS_CLUSTER_NAME:-}}"
KOPS_STATE_STORE="${2:-${KOPS_STATE_STORE:-}}"

# Validate parameters
if [ -z "$KOPS_CLUSTER_NAME" ] || [ -z "$KOPS_STATE_STORE" ]; then
    log "ERROR: Missing required parameters"
    echo "Usage: $0 <cluster-name> <state-store>"
    echo "  or set KOPS_CLUSTER_NAME and KOPS_STATE_STORE env vars"
    echo "Example: $0 my-cluster.k8s.local my-kops-state"
    exit 1
fi

log "Destroying cluster: $KOPS_CLUSTER_NAME"
log "State store: $KOPS_STATE_STORE"

# Confirm destruction
read -p "Are you sure you want to destroy this cluster? (yes/no): " confirm
[ "$confirm" != "yes" ] && { log "Destruction aborted by user"; exit 0; }

# Delete kops cluster first
log "Deleting kops cluster..."
kops delete cluster --name="$KOPS_CLUSTER_NAME" --state="$KOPS_STATE_STORE" --yes 2>&1 | tee -a "$LOG_FILE" || log "WARNING: Cluster deletion failed"

# Destroy kops infrastructure
if [ -d "$PROJECT_DIR/kops-infra" ]; then
    log "Destroying kops infrastructure..."
    cd $PROJECT_DIR/kops-infra
    terraform init -input=false -backend-config=backend.hcl 2>&1 | tee -a "$LOG_FILE"
    if ! terraform destroy -auto-approve 2>&1 | tee -a "$LOG_FILE"; then
        log "ERROR: Infrastructure destroy failed - exiting"
        exit 1
    fi
    cd - > /dev/null
    log "Infrastructure destroyed"
fi

# Clean S3 state store completely
log "Cleaning S3 state store..."
aws s3 rm "$KOPS_STATE_STORE" --recursive 2>/dev/null || true
aws s3api list-object-versions --bucket "$KOPS_STATE_STORE" --query 'Versions[].{Key:Key,VersionId:VersionId}' --output text 2>/dev/null | while read key version; do
    [ -n "$key" ] && aws s3api delete-object --bucket "$KOPS_STATE_STORE" --key "$key" --version-id "$version" 2>/dev/null || true
done
aws s3api list-object-versions --bucket "$KOPS_STATE_STORE" --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output text 2>/dev/null | while read key version; do
    [ -n "$key" ] && aws s3api delete-object --bucket "$KOPS_STATE_STORE" --key "$key" --version-id "$version" 2>/dev/null || true
done
log "S3 state store cleaned"

# Destroy kops-init infrastructure
if [ -d "$PROJECT_DIR/kops-init" ]; then
    log "Destroying kops-init infrastructure..."
    cd $PROJECT_DIR/kops-init
    terraform init -input=false 2>&1 | tee -a "$LOG_FILE"
    terraform destroy -auto-approve 2>&1 | tee -a "$LOG_FILE" || log "WARNING: Init infrastructure destroy failed"
    cd - > /dev/null
    log "Init infrastructure destroyed"
fi

log "Cluster destruction completed"
log "Destruction log file: $LOG_FILE"
