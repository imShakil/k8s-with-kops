# Internal Develop Platform For K8s cluster on AWS with Terraform & Kops

This repository contains Terraform configurations and Kops setup scripts to create and manage a Kubernetes cluster on AWS. It is designed to facilitate internal development and deployment of applications within a Kubernetes environment.

## Project Details

- Purpose: Internal development platform for managing Kubernetes clusters on AWS
- Primary Tools: Terraform & Kops

## Structure

- terraform/ - Contains infrastructure-as-code configurations
  - main.tf - Main Terraform configuration
  - modules/ - Terraform modules
    - ecr
    - vpc
    - rds
    - ec2
    - iam
    - ...
  - variables.tf - Variables for Terraform configurations
  - outputs.tf - Outputs from Terraform configurations

- docs/ - Documentation
  - deployment.md - Deployment guidelines (in progress)
  - developer-guidelines.md - Developer guidelines (in progress)

- clusters/ - Contains cluster templates
  - cluster.yaml - Cluster template for kOps

- scripts/ - Utility scripts
  - setup.sh - Script for setting up the environment

- kops/ - Contains kOps terraform files

## Approach

- Create VPC, S3, IAM user for kops using Terraform. Separate each as modules in [terraform/modules](./terraform/modules/) directory
- Define cluster template in YAML files in [clusters](./clusters/) directory
- Use kOps to create cluster terraform files
- Use Terraform to create the cluster

## Prerequisites

- AWS account with appropriate permissions
- Terraform installed
- kOps installed
- kubectl installed

## Documentation

- [Deployment Guidelines](./docs/deployment.md) (in progress)
- [Developer Guidelines](./docs/developer-guidelines.md) (in progress)

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.

## License

This project is not licensed and is intended for internal use only.
