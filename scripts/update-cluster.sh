#!/bin/bash

set -e
set -x

CLUSTER_NAME="$1"
STATE_STORE="$2"
NODE_COUNT="$3"
NODE_SIZE="$4"
MASTER_SIZE="$5"

echo "Updating cluster configuration..."

# Get and update instance groups
kops get ig --name="$CLUSTER_NAME" --state="$STATE_STORE" -o yaml > /tmp/igs.yaml

# Update nodes instance group
kops get ig nodes --name="$CLUSTER_NAME" --state="$STATE_STORE" -o yaml | \
  sed "s/minSize: .*/minSize: $NODE_COUNT/" | \
  sed "s/maxSize: .*/maxSize: $NODE_COUNT/" | \
  sed "s/machineType: .*/machineType: $NODE_SIZE/" | \
  kops replace -f - --name="$CLUSTER_NAME" --state="$STATE_STORE"

# Update master instance groups
for master_ig in $(kops get ig --name="$CLUSTER_NAME" --state="$STATE_STORE" | grep master | awk '{print $1}'); do
  kops get ig "$master_ig" --name="$CLUSTER_NAME" --state="$STATE_STORE" -o yaml | \
    sed "s/machineType: .*/machineType: $MASTER_SIZE/" | \
    kops replace -f - --name="$CLUSTER_NAME" --state="$STATE_STORE"
done

# Update cluster
kops update cluster --name="$CLUSTER_NAME" --state="$STATE_STORE" --yes --out ../kops --target terraform

# Apply changes
cd ../kops
terraform apply -auto-approve