#!/bin/bash

set -euo pipefail

# Setup logging
LOG_DIR="/var/log/kops"
LOG_FILE="$LOG_DIR/destroy-cluster-$(date +%Y%m%d-%H%M%S).log"
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting cluster destruction script"

# Get parameters
CLUSTER_NAME="${1:-${CLUSTER_NAME:-}}"
KOPS_STATE_STORE="${2:-${KOPS_STATE_STORE:-}}"

# Validate parameters
if [ -z "$CLUSTER_NAME" ] || [ -z "$KOPS_STATE_STORE" ]; then
    log "ERROR: Missing required parameters"
    echo "Usage: $0 <cluster-name> <state-store>"
    echo "  or set CLUSTER_NAME and KOPS_STATE_STORE env vars"
    echo "Example: $0 my-cluster.k8s.local my-kops-state"
    exit 1
fi

log "Destroying cluster: $CLUSTER_NAME"
log "State store: s3://$KOPS_STATE_STORE"

# Confirm destruction
read -p "Are you sure you want to destroy this cluster? (yes/no): " confirm
[ "$confirm" != "yes" ] && { log "Destruction aborted by user"; exit 0; }

# Delete kops cluster first
log "Deleting kops cluster..."
kops delete cluster --name="$CLUSTER_NAME" --state="s3://$KOPS_STATE_STORE" --yes 2>&1 | tee -a "$LOG_FILE" || log "WARNING: Cluster deletion failed"

# Destroy kops infrastructure
if [ -d "../kops-infra" ]; then
    log "Destroying kops infrastructure..."
    cd ../kops-infra
    terraform init -input=false 2>&1 | tee -a "$LOG_FILE"
    terraform destroy -auto-approve 2>&1 | tee -a "$LOG_FILE" || log "WARNING: Infrastructure destroy failed"
    cd - > /dev/null
fi

# Clean S3 state store completely
log "Cleaning S3 state store..."
aws s3 rm "s3://$KOPS_STATE_STORE" --recursive 2>/dev/null || true
aws s3api list-object-versions --bucket "$KOPS_STATE_STORE" --query 'Versions[].{Key:Key,VersionId:VersionId}' --output text 2>/dev/null | while read key version; do
    [ -n "$key" ] && aws s3api delete-object --bucket "$KOPS_STATE_STORE" --key "$key" --version-id "$version" 2>/dev/null || true
done
aws s3api list-object-versions --bucket "$KOPS_STATE_STORE" --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output text 2>/dev/null | while read key version; do
    [ -n "$key" ] && aws s3api delete-object --bucket "$KOPS_STATE_STORE" --key "$key" --version-id "$version" 2>/dev/null || true
done

# Destroy kops-init infrastructure
if [ -d "../kops-init" ]; then
    log "Destroying kops-init infrastructure..."
    cd ../kops-init
    terraform init -input=false 2>&1 | tee -a "$LOG_FILE"
    terraform destroy -auto-approve 2>&1 | tee -a "$LOG_FILE" || log "WARNING: Init infrastructure destroy failed"
    cd - > /dev/null
fi

log "Cluster destruction completed"
log "Destruction log file: $LOG_FILE"
