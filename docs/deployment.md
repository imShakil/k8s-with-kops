# Deployment Guidelines

## Overview

This guide walks through deploying a Kubernetes cluster on AWS using Terraform for infrastructure provisioning and Kops for cluster management.

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.5.0
- Kops >= 1.34
- kubectl >= 1.34
- Domain name for cluster (optional)

## Step 1: Fresh VM Setup

### 1.1 Clone Repository

```bash
git clone https://github.com/imShakil/k8s-with-kops.git
cd k8s-with-kops
```

### 1.2 Prepare VM Environment

For a clean deployment, use a fresh VM with the required tools:

```bash
# Run the VM preparation script
bash ./scripts/prepare-vm.sh
```

This script will:

- Install AWS CLI
- Install Terraform
- Install Kops
- Install kubectl
- Configure basic environment

You can also manually install the required tools if you prefer. And ignore the script if you already have them installed.

### 1.3 Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region, and output format
```

> Make sure you have the necessary IAM permissions to create resources in AWS.

**Required IAM Permissions for Initial Setup:**

- IAMFullAccess (to create kops admin user and policies)
- AmazonS3FullAccess (to create kops state bucket)
- AmazonEC2FullAccess (to query availability zones)

**The kops-init will create a dedicated kops admin user with these permissions:**

- EC2 Full Access (ec2:*)
- Route53 Full Access (route53:*)
- IAM Full Access (iam:*)
- SQS Full Access (sqs:*)
- EventBridge Full Access (events:*)
- S3 Full Access (s3:*)
- RDS Full Access (rds:*)
- ELB Full Access (elasticloadbalancing:*)
- Auto Scaling Full Access (autoscaling:*)
- EBS Full Access (ebs:*)
- CloudWatch Full Access (cloudwatch:*, logs:*)
- ECR Full Access (ecr:*)

## Step 2: Initialize Infrastructure

### 2.1 Initialize Terraform

- Go to `kops-init` directory
- Copy `terraform.tfvars.example` to `terraform.tfvars` and update the values

    ```sh
    cp terraform.tfvars.example terraform.tfvars
    ```

- If you want to use remote backend, Copy `backend.tf.example` to `backend.tf` and update the values

    ```sh
    cp backend.tf.example backend.tf
    ```

    > If you want to use remote backend, you need to configure the backend first.

- Initialize Terraform

    ```sh
    terraform init
    ```

### 2.2 Update Terraform Variables

Update the variables in `terraform.tfvars`:

```hcl
env    = "dev"
prefix = "kops"
region = "ap-southeast-1"

cluster_name     = "awslab.mhosen.com"
kops_node_count  = "3"
kops_node_size   = "t2.small"
kops_master_size = "t2.medium"
```

- Use Fully Qualified Domain as Cluster Name
- For local:
  - It could be like this: `demo.k8s.local`; make sure you have used `k8s.local` at the end
  - For public DNS: You have to use aws hosted zone; `awslab.example.com`

### 2.3 Plan and Apply Infrastructure

```bash
terraform plan
terraform apply -auto-approve
```

This creates:

- S3 bucket for Kops state
- IAM user and policies for Kops
- Initiates Cluster configs
- Generates cluster provisioning terraform files in `kops-infra` directory
- Configure AWS CLI with newly created IAM User

It will print the following output like this:

```hcl
kops_admin_credentials = <sensitive>
kops_init = {
  "cluster_name" = "kopsdemo.k8s.local"
  "iam_user_arn" = "arn:aws:iam::703671893711:user/kops-staging-admin"
  "iam_user_name" = "kops-staging-admin"
  "state_bucket" = "kops-state-staging-ap-southeast-1"
}
```

> Keep notes these value, we need to use them frequently.

### 2.4: Export Variables

It's better to export them as environment variables:

- Run the following command:

```sh
terraform output -raw export_variables
```

- Copy and paste the output to your terminal

> This will ensure kops will use right IAM User

## Step 3: Provisoning kOps Cluster With Terraform

### 3.1: Provision Cluster

- Go to kops-infra directory and initialize terraform

```bash
cd ../kops-infra
terraform init -backend-config=backend.hcl
```

- Plan and Apply

```bash
terraform plan
terraform apply -auto-approve
```

### 3.2: Setup kubectl context

```sh
kops export kubeconfig --name=your-cluster-name --state=s3://bucket-name --admin
```

Or if you have exported the variables:

```bash
kops export kubeconfig --admin
```

> This will create a kubeconfig file in `~/.kube/config`

### 3.3 Validate Cluster

```bash
kops validate cluster --wait 10m
kubectl get nodes -o wide
```

> If you are using public dns, then use longer wait time (15-20m).

## Step 4: Application Deployment

### 4.1 Create Namespaces

```bash
kubectl create namespace development
kubectl create namespace staging
kubectl create namespace production
kubectl get pods
kubectl get ns
```

## Step 5: Destroy Cluster

<details>

<summary>Using Bash Script (Recommended)</summary>

> You can destroy the cluster using the bash script `destroy-cluster.sh` in the `scripts` directory.

**Usage:**

```bash
cd scripts
./destroy-cluster.sh <cluster-name> <state-store> <aws-profile>
```

**Example:**

```bash
./destroy-cluster.sh my-cluster.k8s.local s3://my-kops-state kops-profile
```

**Or using environment variables:**

```bash
export KOPS_CLUSTER_NAME=my-cluster.k8s.local
export KOPS_STATE_STORE=s3://my-kops-state
export AWS_PROFILE=kops-profile
bash ./destroy-cluster.sh
```

**What the script does:**

1. Logs all operations to `~/kops/destroy-cluster.log`
2. Deletes kops cluster resources
3. Destroys kops-infra Terraform resources
4. Cleans S3 state store completely (including versioned objects)
5. Destroys kops-init Terraform resources

</details>

<details>

<summary>Manual Destruction Steps</summary>

### 5.1: Delete kOps Infra

```bash
cd ../kops-infra
terraform destroy -auto-approve
```

### 5.2: Delete Cluster

```bash
kops delete cluster --name=your-cluster-name --state=s3://bucket-name --yes
```

Or if you have exported the variables:

```bash
kops delete cluster --yes
```

### 5.3: Delete kOps Init Infra

- Setting AWS Profile

```bash
export AWS_PROFILE=default
```

- Delete kOps Init Infra

```bash
cd ../kops-init
terraform destroy -auto-approve
```

> The destroy script will handle S3 bucket cleanup automatically, including versioned objects and delete markers.

</details>
