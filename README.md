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
