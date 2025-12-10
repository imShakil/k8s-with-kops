#!/bin/bash

set -euo pipefail

# Detect project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Setup logging
LOG_DIR="$HOME/kops"
LOG_FILE="$LOG_DIR/destroy-cluster.log"
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting cluster destruction script"
log "Project directory: $PROJECT_DIR"

# Validate project structure
if [ ! -d "$PROJECT_DIR/kops-init" ] && [ ! -d "$PROJECT_DIR/kops-infra" ]; then
    log "ERROR: Invalid project directory structure"
    log "Make sure you're running this script from within the k8s-with-kops project"
    exit 1
fi

# Get parameters
KOPS_CLUSTER_NAME="${1:-${KOPS_CLUSTER_NAME:-}}"
KOPS_STATE_STORE="${2:-${KOPS_STATE_STORE:-}}"
AWS_PROFILE="${3:-${AWS_PROFILE:-}}"

# Validate parameters
if [ -z "$KOPS_CLUSTER_NAME" ] || [ -z "$KOPS_STATE_STORE" ] || [ -z "$AWS_PROFILE" ]; then
    log "ERROR: Missing required parameters"
    echo "Usage: $0 <cluster-name> <state-store> <aws-profile>"
    echo "  or set KOPS_CLUSTER_NAME, KOPS_STATE_STORE, and AWS_PROFILE env vars"
    echo "Example: $0 my-cluster.k8s.local s3://my-kops-state kops-profile"
    exit 1
fi

# Set AWS profile
export AWS_PROFILE="$AWS_PROFILE"

log "Destroying cluster: $KOPS_CLUSTER_NAME"
log "State store: $KOPS_STATE_STORE"
log "AWS Profile: $AWS_PROFILE"

# Confirm destruction
read -p "Are you sure you want to destroy this cluster? (yes/no): " confirm
[ "$confirm" != "yes" ] && { log "Destruction aborted by user"; exit 0; }

# Delete kops cluster first
log "Deleting kops cluster..."
kops delete cluster --name="$KOPS_CLUSTER_NAME" --state="$KOPS_STATE_STORE" --yes 2>&1 | tee -a "$LOG_FILE" || log "WARNING: Cluster deletion failed"

# Destroy kops infrastructure
if [ -d "$PROJECT_DIR/kops-infra" ]; then
    log "Destroying kops infrastructure..."
    cd "$PROJECT_DIR/kops-infra"
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
set +e  # Disable exit on error for S3 cleanup

# Extract bucket name from s3:// URL
BUCKET_NAME=$(echo "$KOPS_STATE_STORE" | sed 's|s3://||')

aws s3 rm "$KOPS_STATE_STORE" --recursive 2>/dev/null || log "WARNING: S3 recursive delete failed"

# Clean object versions
versions=$(aws s3api list-object-versions --bucket "$BUCKET_NAME" --query 'Versions[].{Key:Key,VersionId:VersionId}' --output text 2>/dev/null || true)
if [ -n "$versions" ]; then
    echo "$versions" | while read key version; do
        [ -n "$key" ] && aws s3api delete-object --bucket "$BUCKET_NAME" --key "$key" --version-id "$version" 2>/dev/null || true
    done
fi

# Clean delete markers
markers=$(aws s3api list-object-versions --bucket "$BUCKET_NAME" --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output text 2>/dev/null || true)
if [ -n "$markers" ]; then
    echo "$markers" | while read key version; do
        [ -n "$key" ] && aws s3api delete-object --bucket "$BUCKET_NAME" --key "$key" --version-id "$version" 2>/dev/null || true
    done
fi

set -e  # Re-enable exit on error
log "S3 state store cleanup completed"

# Destroy kops-init infrastructure
if [ -d "$PROJECT_DIR/kops-init" ]; then
    log "Destroying kops-init infrastructure..."
    export AWS_PROFILE=default
    cd "$PROJECT_DIR/kops-init"
    terraform init -input=false 2>&1 | tee -a "$LOG_FILE"
    if ! terraform destroy -auto-approve 2>&1 | tee -a "$LOG_FILE"; then
        log "ERROR: Infrastructure destroy failed - exiting"
        exit 1
    fi
    cd - > /dev/null
    log "Infrastructure destroyed"
fi

log "Cluster destruction completed"
log "Destruction log file: $LOG_FILE"
