#!/bin/bash

# Check if backend config exists
if [ ! -f "backend.hcl" ]; then
    echo "Error: backend.hcl not found. Copy from backend.hcl.example and customize."
    echo "cp backend.hcl.example backend.hcl"
    exit 1
fi

# Initialize terraform with backend config
terraform init -backend-config=backend.hcl