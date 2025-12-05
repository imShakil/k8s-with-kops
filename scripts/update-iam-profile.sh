#!/bin/bash
# This script configures AWS CLI profile for kops
set -e

# Setup logging
LOG_DIR="/var/log/kops"
LOG_FILE="$LOG_DIR/update-iam-profile-$(date +%Y%m%d-%H%M%S).log"
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

log "Starting IAM profile update script"

# Use environment variables
AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-}"
AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-}"
AWS_REGION="${AWS_REGION:-}"
AWS_PROFILE="${KOPS_USER_NAME:-kops}"

log "Configuration:"
log "  AWS_REGION: $AWS_REGION"
log "  AWS_PROFILE: $AWS_PROFILE"

# Validate required environment variables
log "Validating environment variables..."
[ -z "$AWS_ACCESS_KEY_ID" ] && error_exit "AWS_ACCESS_KEY_ID environment variable is required"
[ -z "$AWS_SECRET_ACCESS_KEY" ] && error_exit "AWS_SECRET_ACCESS_KEY environment variable is required"
[ -z "$AWS_REGION" ] && error_exit "AWS_REGION environment variable is required"
log "Environment variables validated successfully"

# Configure AWS CLI
log "Configuring AWS CLI profile: $AWS_PROFILE"
aws configure --profile $AWS_PROFILE set aws_access_key_id "$AWS_ACCESS_KEY_ID" 2>&1 | tee -a "$LOG_FILE"
aws configure --profile $AWS_PROFILE set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" 2>&1 | tee -a "$LOG_FILE"
aws configure --profile $AWS_PROFILE set region "$AWS_REGION" 2>&1 | tee -a "$LOG_FILE"

# Set as default AWS profile
# log "Setting as default AWS profile"
# aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" 2>&1 | tee -a "$LOG_FILE"
# aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" 2>&1 | tee -a "$LOG_FILE"
# aws configure set region "$AWS_REGION" 2>&1 | tee -a "$LOG_FILE"

export AWS_PROFILE="$AWS_PROFILE"

# Make profile persistent in current shell session
echo "export AWS_PROFILE=$AWS_PROFILE" >> ~/.bashrc

log "AWS CLI profile configured successfully: $AWS_PROFILE"
log "Profile exported and made persistent for future sessions"
log "IAM profile update completed. Log file: $LOG_FILE"
