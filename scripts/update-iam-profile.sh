#!/bin/bash
# This script configures AWS CLI profile for kops
set -e
set -x

# Error handling function
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Use environment variables
AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-}"
AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-}"
AWS_REGION="${AWS_REGION:-}"
AWS_PROFILE="${KOPS_USER_NAME:-kops}"

# Validate required environment variables
[ -z "$AWS_ACCESS_KEY_ID" ] && error_exit "AWS_ACCESS_KEY_ID environment variable is required"
[ -z "$AWS_SECRET_ACCESS_KEY" ] && error_exit "AWS_SECRET_ACCESS_KEY environment variable is required"
[ -z "$AWS_REGION" ] && error_exit "AWS_REGION environment variable is required"

# Configure AWS CLI
aws configure --profile $AWS_PROFILE set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure --profile $AWS_PROFILE set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure --profile $AWS_PROFILE set region "$AWS_REGION"

export AWS_PROFILE="$AWS_PROFILE"
