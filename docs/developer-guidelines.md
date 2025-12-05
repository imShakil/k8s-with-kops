# Developer Access Guide

Welcome to the Internal Developer Platform! This guide helps you access the Kubernetes Development Environment.

## 🛠️ Prerequisites

You need the following tools installed on your local machine:
1.  **AWS CLI**: [Install Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2.  **kubectl**: [Install Guide](https://kubernetes.io/docs/tasks/tools/)
3.  **Lens** (Optional but Recommended): A visual dashboard for Kubernetes.
4.  **Kops**: [Install Kops](https://kops.sigs.k8s.io/getting_started/install/)
---

## 🔐 Getting Access

## Step 1: Configure AWS Credentials
Ensure you have access to the AWS account. Run the following to set up your profile:
```bash
aws configure
```
#Enter your Access Key, Secret Key, and Region (ap-southeast-1) 


## Step 2: Download Cluster Configuration
We use kops to generate your local kubeconfig file. You do not need to be an admin; you just need IAM permissions to read the S3 state store.

1. Export the State Store Variable: (Ask your Tech Lead for the specific bucket name if not listed below)
```bash
export KOPS_STATE_STORE=s3://idp-kops-state-store-xxxxxxx  #use bucket name as listed below or provided by TL
```

2. Download the Config:
```bash
kops export kubecfg --name awslab.mhosen.com  #awslab.mhosen.com is the cluster name
```

3. Verify Connection:
```bash
kubectl get pods -A
```

🚀 Working with the Cluster

Deploying Your Application
We use standard Kubernetes manifests.

1. Create a namespace for your work:

```Bash
kubectl create namespace my-feature-branch
```

2. Apply your manifests:

```Bash
kubectl apply -f deployment.yaml -n my-feature-branch
```

##Connecting to the Database

The Aurora Database is running in the private subnet.

- Host: Retrieve from SSM Parameter /idp/dev/db_endpoint or ask the Platform Team. #We store infrastructure IDs in SSM so Kops automation can find them easily

- Access: Your pods can connect directly on port 3306.

- Local Access: For security, direct local access is blocked. Use kubectl port-forward to test database connectivity if strictly necessary (requires a bastion pod).

Viewing Logs
To see logs for your application:

```Bash
kubectl logs -f -l app=my-app -n my-feature-branch
```

⚠️ Important Rules

No Manual Changes: Do not edit resources (Deployments, Services) manually via the AWS Console. Everything is managed via code.

Statelessness: Do not store files on the pods. They will be lost when pods restart. Use S3 or the Database.