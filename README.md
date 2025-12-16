# Internal Developer Platform For K8S cluster on AWS with Terraform & Kops

[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=imShakil_k8s-with-kops&metric=ncloc)](https://sonarcloud.io/summary/new_code?id=imShakil_k8s-with-kops)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=imShakil_k8s-with-kops&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=imShakil_k8s-with-kops)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=imShakil_k8s-with-kops&metric=coverage)](https://sonarcloud.io/summary/new_code?id=imShakil_k8s-with-kops)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=imShakil_k8s-with-kops&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=imShakil_k8s-with-kops)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=imShakil_k8s-with-kops&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=imShakil_k8s-with-kops)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=imShakil_k8s-with-kops&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=imShakil_k8s-with-kops)
[![Duplicated Lines (%)](https://sonarcloud.io/api/project_badges/measure?project=imShakil_k8s-with-kops&metric=duplicated_lines_density)](https://sonarcloud.io/summary/new_code?id=imShakil_k8s-with-kops)

This repository contains Terraform configurations and Kops setup scripts to create and manage a Kubernetes cluster on AWS.
It is designed to facilitate internal development and deployment of applications within a Kubernetes environment.

## Table of Contents

- [What is IDP?](#what-is-idp)
- [Project Details](#project-details)
- [Structure](#structure)
- [Pre-requisites](#prerequisites)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## What is IDP?

IDP is an internal development platform designed to streamline the creation and management of Kubernetes clusters on AWS. It leverages Terraform for infrastructure provisioning and Kops for Kubernetes cluster management, providing a robust foundation for deploying and scaling applications.

## Project Details

- Purpose: Internal development platform for managing Kubernetes clusters on AWS
- Primary Tools:
  - Terraform
  - Kops
  - AWS CLI
  - Kubectl
  - GitHub Actions

## Structure

```files
── README.md
├── docs
│   ├── deployment.md
│   ├── developer-guidelines.md
│   └── setup_cluster_domain.md
├── kops-infra
│   └── backend.tf
├── kops-init
│   ├── backend.tf.example
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── README.md
│   ├── terraform.tfvars.example
│   ├── variables.tf
│   └── templates
│       └── backend.hcl.tpl
├── scripts
│   ├── create-cluster.sh
│   ├── destroy-cluster.sh
│   ├── prepare-vm.sh
│   ├── README.md
│   └── update-iam-profile.sh
└── tf-modules
    ├── ec2
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── ecr
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── envs
    │   ├── dev.tfvars
    │   ├── prod.tfvars
    │   ├── README.md
    │   └── stage.tfvars
    ├── iam
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── rds
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── s3
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── vpc
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

**Structure Overview**:

- `kops-infra/`: Contains Terraform configurations for the Kops infrastructure.
- `kops-init/`: Contains Terraform configurations for initializing Kops.
- `scripts/`: Contains scripts for cluster management and VM preparation.
- `tf-modules/`: Contains reusable Terraform modules for various AWS resources.
- `docs/`: Contains documentation for deployment and developer guidelines.

## Prerequisites

- AWS account with appropriate permissions
- Terraform installed
- kOps installed
- kubectl installed

## Documentation

Want to build you own internal developer platform for Kubernetes cluster on AWS with Terraform & Kops? Checkout the deployment guidelines and developer guidelines below:

- [Deployment Guidelines](./docs/deployment.md) (in progress)
- [Developer Guidelines](./docs/developer-guidelines.md) (in progress)
- [Setup Cluster Domain](./docs/setup_cluster_domain.md)

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.
Please follow the existing code style and conventions on the [developer guidelines](./docs/developer-guidelines.md).

## License

This project is not licensed and is intended for internal use only.
