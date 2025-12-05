# Kops Infrastructure Setup

## Quick Start (Local State)
```bash
terraform init
terraform apply
```

## Remote Backend (Optional)
For team collaboration:

1. Enable remote backend:
```bash
cp backend.tf.example backend.tf
# Edit backend.tf with your S3 bucket details
```

2. Initialize:
```bash
terraform init
```