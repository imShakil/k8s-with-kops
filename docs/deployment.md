# Deployment Guidelines

## Overview

This guide walks through deploying a Kubernetes cluster on AWS using Terraform for infrastructure provisioning and Kops for cluster management.

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.5.0
- Kops >= 1.25
- kubectl >= 1.25
- Domain name for cluster (recommended)

## Step 1: Get Ready

### 1.1 Initialize Terraform

```bash
cd kops-init/
terraform init
```

### 1.2 Configure Variables

Create `terraform.tfvars`:

```hcl
env    = "dev"
prefix = "kops"
region = "ap-southeast-1"

cluster_name     = "awslab.mhosen.com"
kops_node_count  = "3"
kops_node_size   = "t2.small"
kops_master_size = "t2.medium"
```

> Use Fully Qualified Domain as Cluster Name
> for local: it could be like this: [anything-you-want-here].k8s.local
> For public DNS: aws hosted zone; ex: awslab.example.com

### 1.3 Plan and Apply Infrastructure

```bash
terraform plan
terraform apply -auto-approve
```

This creates:

- S3 bucket for Kops state
- IAM user and policies for Kops
- Initiates Cluster configs
- Generates cluster provisioning terraform files in `kops-infra` directory
- Configure AWS CLI with new created IAM User

## Step 2: Provisoning kOps Cluster With Terraform

### 2.1: Provision Cluster

```bash
cd kops-infra
terraform init
terraform plan
terraform apply -auto-approve
```

### 2.2: Setup kubectl context

```sh
kops export kubeconfig --name=your-cluster-name --state=s3://bucket-name --admin
```

### 2.3 Validate Cluster

```bash
kops validate cluster --wait 10m
kubectl get nodes -o wide
```

> If you are using public dns, then use longer wait time (15-20m).

## Step 3: Application Deployment

### 3.1 Create Namespaces

```bash
kubectl create namespace development
kubectl create namespace staging
kubectl create namespace production
kubectl get pods
kubectl get ns
```
