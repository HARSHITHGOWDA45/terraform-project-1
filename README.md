🚀 Terraform CI/CD Infrastructure on AWS
📌 Project Overview

This project demonstrates a production-style Infrastructure as Code (IaC) implementation using:

Terraform

GitHub Actions

AWS

Branch-based environment deployments (dev/test/prod)

The infrastructure is deployed automatically using CI/CD pipelines and follows best practices like:

Modular Terraform structure

Remote state management using S3

State locking using DynamoDB

Auto Scaling & Load Balancing

Private/Public subnet architecture

🏗 Architecture Diagram
High-Level CI/CD Flow

Developer → GitHub → GitHub Actions → Terraform → AWS Infrastructure

CI/CD Flow:

Developer pushes code to:

dev branch → Deploys dev environment

test branch → Deploys test environment

main branch → Deploys production environment

GitHub Actions performs:

Checkout repository

Terraform init

Terraform validate

TFLint & Trivy scan

Terraform plan

Terraform apply (based on branch)


🌐 AWS Infrastructure Architecture
VPC (10.0.0.0/16)

2 Public Subnets

2 Private Subnets

Internet Gateway

NAT Gateway (for private subnet outbound access)

Application Load Balancer (Public)

EC2 Instances (Private Subnets)

Auto Scaling Group

S3 Backend (Terraform State)

🔁 Traffic Flow

User → Internet → ALB (Public Subnet) → EC2 (Private Subnet)

Outbound Internet:
EC2 → NAT Gateway → Internet


🔐 Remote Backend Configuration

Terraform state is stored securely in:

S3 Bucket

DynamoDB Table (State Locking)


🛠 Setup Instructions
1️⃣ Prerequisites

AWS Account

IAM User with programmatic access

Terraform installed

AWS CLI configured

GitHub repository


2️⃣ Configure AWS Credentials in GitHub

Go to:
GitHub → Settings → Secrets → Actions

Add:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY


3️⃣ Deploy Infrastructure

Push code to specific branches:

git checkout -b dev
git push origin dev


📈 Auto Scaling Configuration

Min: 1

Desired: 2

Max: 5

Ensures high availability and scalability.


🔍 Security Best Practices Implemented

EC2 instances in private subnets

ALB only exposed to internet

Remote state encryption

State locking using DynamoDB

IAM least privilege

Security group restrictions



