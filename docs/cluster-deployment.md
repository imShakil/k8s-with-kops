# kOps Cluster Deployment – GitHub Actions Guide

This repository provides a GitHub Actions–based workflow to deploy and manage a Kubernetes cluster using kOps on AWS.

This README explains:
- How to run the deployment workflow
- What inputs are required
- What happens during deployment
- How to access and validate the cluster after deployment
- Verification and basic troubleshooting steps

> Note:  
> This document does not explain the workflow or pipeline implementation.  
> It is intended for users/operators who need to run and validate the deployment.

---

## Overview

The kOps Cluster Deployment workflow enables you to:

- Provision a Kubernetes cluster on AWS
- Configure master and worker nodes
- Create or update infrastructure automatically
- Validate cluster health after deployment

The workflow is triggered manually from GitHub Actions using `workflow_dispatch`.

---

## Prerequisites

### AWS Account
- An active AWS account
- IAM permissions to create:
  - EC2 instances
  - VPC, subnets, security groups
  - S3 bucket (kOps state store)
  - IAM roles and policies

---

### GitHub Repository Secrets

The following GitHub Secrets must be configured:

| Secret Name | Description |
|------------|------------|
| AWS_ACCESS_KEY_ID | AWS access key |
| AWS_SECRET_ACCESS_KEY | AWS secret key |
| AWS_REGION | AWS region (e.g. ap-south-1) |

Add secrets at:  
`Repository → Settings → Secrets and variables → Actions`

---

## How to Run the Deployment Workflow

1. Open the GitHub repository
2. Navigate to the **Actions** tab
3. Select **kOps Cluster Deployment**
4. Click **Run workflow**
5. Fill in the required inputs
6. Click **Run workflow** to start execution

---

## Deployment Inputs

### Input Descriptions

| Input | Description |
|-----|------------|
| Environment | Target environment (dev, staging, prod) |
| Cluster Name | Cluster name ( `.k8s.local` is auto-appended ) |
| Master Nodes | Number of Kubernetes master nodes |
| Master Size | EC2 instance type for master nodes |
| Worker Nodes | Number of worker nodes |
| Worker Size | EC2 instance type for worker nodes |

---

### Example Input Values

```text
Environment: dev
Cluster name: dev-cluster
Master nodes: 1
Master size: t2.medium
Worker nodes: 2
Worker size: t2.small
```

### Final cluster name:

-  [clusterName].k8s.local

### What Happens During Deployment

- Environment validation is performed
- AWS credentials are loaded from GitHub Secrets
- Required AWS infrastructure is prepared
- kOps creates or updates the Kubernetes cluster
- Master and worker nodes are configured
- Deployment progress is logged in GitHub Actions

### Monitoring Deployment Progress

- Monitor execution at:
- GitHub → Actions → kOps Cluster Deployment → Workflow run
- Logs provide step-by-step execution details and error information if any.

## Prerequisites (Local Machine)

Before proceeding, ensure the following tools are installed and configured locally:

- AWS CLI (configured with valid credentials)
- kubectl
- kops
- Access to the same AWS account used for cluster creation

Verify AWS CLI configuration:

```bash
aws sts get-caller-identity
```

### Download the kubeconfig file:

## Step 1: Download Kubeconfig from S3

Create the kubeconfig directory if it does not exist:

## Step 2: Verify Cluster Access

Run the following command to confirm Kubernetes access:

```bash
kubectl get nodes
```
## Expected Result
-Master and worker nodes should be listed
-Node status should be Ready

## Step 3: Download SSH Key from S3

- Create the SSH directory if it does not exist:

mkdir -p ~/.ssh


## Download the SSH private key from S3:

- aws s3 cp s3://kops/dev/[clusterName].local/ssh-key ~/.ssh/[clusterName].k8s.local-key


## Set secure permissions on the key:

- chmod 600 ~/.ssh/[clusterName].k8s.local-key

## Step 4: SSH into a Cluster Node

- Get the node IP address:

- kubectl get nodes -o wide


## Connect to the node using SSH:

- ssh -i ~/.ssh/[].k8s.local-key ubuntu@<node-ip>


- Replace <node-ip> with the external IP address of the node.

## Step 5: Validate Cluster (Optional)

- Run kOps cluster validation:

- kops validate cluster --name dev-cluster.k8s.local

## Expected Output
- Your cluster [clusterName].k8s.local is ready

## Common Issues
- kubectl Not Connecting

## Ensure kubeconfig exists at ~/.kube/config

- Verify AWS credentials are valid

- Re-download the kubeconfig if required

## SSH Permission Denied

- Ensure the correct username is used (ubuntu)

- Confirm SSH key permissions are set to 600

- Verify the node security group allows SSH access on port 22

## Summary

- Cluster access files are securely stored in S3

- Kubeconfig enables Kubernetes (kubectl) access

- SSH key allows node-level access

- Cluster is ready for application deployment


