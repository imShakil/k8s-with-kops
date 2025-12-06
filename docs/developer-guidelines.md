# Developer Guidelines

This guide provides development standards and access instructions for using the Internal Developer Platform (IDP) Kubernetes cluster.

## 🛠️ Prerequisites

Install required tools:

- **AWS CLI v2**: [Install Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- **kubectl**: [Install Guide](https://kubernetes.io/docs/tasks/tools/) (v1.24+)
- **Docker**: For building container images
- **Lens** (Optional): Visual Kubernetes dashboard
- **kops**: [Install Guide](https://kops.sigs.k8s.io/getting_started/install/) (for cluster management)

## 🔐 Getting Access

### Step 1: Get Cluster Access Variables

Contact your platform team to get the environment variables:

```bash
export KOPS_STATE_STORE=s3://your-kops-state-bucket
export KOPS_CLUSTER_NAME=your-cluster-name
export AWS_PROFILE=your-aws-profile
```

### Step 2: Configure kubectl

```bash
kops export kubecfg --name $KOPS_CLUSTER_NAME
```

### Step 3: Verify Access

```bash
kubectl get nodes
kubectl get namespaces
```

## 🚀 Development Workflow

### Deploying Applications

1. **Create namespace for your feature:**

    ```bash
    kubectl create namespace my-feature
    ```

2. **Deploy your application:**

    ```bash
    kubectl apply -f deployment.yaml -n my-feature
    ```

3. **Check deployment status:**

    ```bash
    kubectl get pods -n my-feature
    kubectl logs -f deployment/my-app -n my-feature
    ```

### Database Access

RDS instances are deployed in private subnets:

- **Connection**: Pods connect directly via internal DNS
- **Local Access**: Use `kubectl port-forward` through a bastion pod
- **Credentials**: Stored in AWS Secrets Manager

### Container Registry

Use the ECR repositories created by Terraform:

```bash
# Get ECR login
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-southeast-1.amazonaws.com

# Build and push
docker build -t my-app .
docker tag my-app:latest <account-id>.dkr.ecr.ap-southeast-1.amazonaws.com/my-app:latest
docker push <account-id>.dkr.ecr.ap-southeast-1.amazonaws.com/my-app:latest
```

## ⚠️ Development Rules

1. **Infrastructure as Code**: All infrastructure changes via Terraform
2. **No Manual AWS Console Changes**: Use kubectl and Terraform only
3. **Stateless Applications**: Store data in RDS/S3, not in pods
4. **Namespace Isolation**: Use separate namespaces for features
5. **Resource Limits**: Set CPU/memory limits in deployments
6. **Security**: Use IAM roles, not hardcoded credentials
7. **Image Tagging**: Use semantic versioning (v1.0.0) or commit SHA for container images
8. **Secrets Management**: Store sensitive data in AWS Secrets Manager, not in ConfigMaps

## 📋 Deployment Best Practices

### YAML Structure

- Always include resource requests and limits
- Use health checks (liveness and readiness probes)
- Set appropriate restart policies
- Use labels for pod selection and organization

### Example Deployment Template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: my-feature
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: <account-id>.dkr.ecr.ap-southeast-1.amazonaws.com/my-app:v1.0.0
        ports:
        - containerPort: 8080
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

### Namespace Naming Convention

Use format: `{team}-{feature}` or `{team}-{environment}`

- Example: `platform-auth`, `backend-payment`

## 💻 Local Development

### Testing Locally Before Deployment

1. **Build and test Docker image locally:**

   ```bash
   docker build -t my-app:test .
   docker run -p 8080:8080 my-app:test
   ```

2. **Use kind or minikube for local Kubernetes testing:**

   ```bash
   # Test deployment locally
   kubectl apply -f deployment.yaml -n my-feature
   kubectl port-forward svc/my-app 8080:8080 -n my-feature
   ```

3. **Validate YAML before deployment:**

   ```bash
   kubectl apply -f deployment.yaml --dry-run=client -o yaml
   ```

### Useful kubectl Commands

```bash
# Port forwarding to access services
kubectl port-forward svc/my-service 8080:8080 -n my-feature

# Stream logs from deployment
kubectl logs -f deployment/my-app -n my-feature

# Execute commands in pod
kubectl exec -it <pod-name> -n my-feature -- /bin/bash

# Get resource usage
kubectl top nodes
kubectl top pods -n my-feature

# Watch pod status
kubectl get pods -n my-feature -w
```

## 🔧 Troubleshooting

### Common Issues

**kubectl connection issues:**

```bash
# Re-export cluster config
kops export kubecfg --name $KOPS_CLUSTER_NAME
```

**AWS profile issues:**

```bash
# Check current profile
aws sts get-caller-identity

# Switch profile
export AWS_PROFILE=kops-profile
```

**Pod deployment issues:**

```bash
# Check events
kubectl get events -n my-feature --sort-by='.lastTimestamp'

# Describe pod
kubectl describe pod <pod-name> -n my-feature
```

### Common Gotchas

**ImagePullBackOff Error:**

- Verify ECR credentials are correct
- Check image URI matches ECR repository
- Ensure image tag exists in ECR

**CrashLoopBackOff:**

- Check pod logs: `kubectl logs <pod-name> -n my-feature`
- Verify application starts without errors
- Check resource limits aren't too restrictive

**Pending Pods:**

- Check node capacity: `kubectl top nodes`
- Verify resource requests don't exceed available resources
- Check for node selectors or taints

**Connection Refused to Database:**

- Verify RDS security group allows pod traffic
- Check database credentials in Secrets Manager
- Ensure pod has network access to private subnet

## 🚨 Quick Reference

| Task | Command |
|------|---------|
| List all namespaces | `kubectl get namespaces` |
| Create namespace | `kubectl create namespace my-feature` |
| Deploy app | `kubectl apply -f deployment.yaml -n my-feature` |
| View pods | `kubectl get pods -n my-feature` |
| View logs | `kubectl logs -f deployment/my-app -n my-feature` |
| Port forward | `kubectl port-forward svc/my-app 8080:8080 -n my-feature` |
| Describe pod | `kubectl describe pod <pod-name> -n my-feature` |
| Delete deployment | `kubectl delete deployment my-app -n my-feature` |
| Get events | `kubectl get events -n my-feature --sort-by='.lastTimestamp'` |
| ECR login | `aws ecr get-login-password --region ap-southeast-1 \| docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-southeast-1.amazonaws.com` |

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kOps Documentation](https://kops.sigs.k8s.io/)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
