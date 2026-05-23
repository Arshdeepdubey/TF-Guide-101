# Terraform AWS S3 Example & CI/CD Guide

This module creates a versioned, private S3 bucket using the community `terraform-aws-modules/s3-bucket/aws` module.

Prerequisites:
- Terraform >= 1.3
- AWS credentials configured via environment variables or `~/.aws` config

Quick start:
1. Initialize providers and modules:
   ```bash
   terraform init
   ```
2. Review the plan:
   ```bash
   terraform plan
   ```
3. Apply the changes:
   ```bash
   terraform apply -auto-approve
   ```
4. To destroy resources:
   ```bash
   terraform destroy -auto-approve
   ```
5. For CI/CD, set up the GitHub Actions workflow as described below. Save this file exactly as-is under your repository path at `.github/workflows/cicd.yml`. This configuration uses modern OpenID Connect (OIDC) authentication to connect to AWS without using long-lived secrets.

   ```yaml
   name: Terraform CI/CD
   on:
     push:
       branches:
         - main
         - 'feature/*'
     pull_request:
       branches:
         - main
   
   # Required permissions block for AWS OIDC authentication handshake
   permissions:
     id-token: write
     contents: read
   
   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
   
         # Log into AWS securely using the Account-Wide OIDC Identity Role
         - name: Configure AWS Credentials
           uses: aws-actions/configure-aws-credentials@v4
           with:
             audience: sts.amazonaws.com
             aws-region: us-east-1 # Change to your preferred target region if different
             role-to-assume: arn:aws:iam::YOUR_AWS_ACCOUNT_ID:role/github-actions-global-oidc-role
   
         - name: Set up Terraform
           uses: hashicorp/setup-terraform@v3
   
         - name: Terraform Init
           run: terraform init
   
         - name: Terraform Plan
           run: terraform plan
   
         - name: Terraform Apply
           if: github.event_name == 'push'
           run: terraform apply -auto-approve
   
         - name: Terraform Destroy or Notify
           run: |
             if [ "${{ github.event_name }}" = "push" ]; then
               echo "Running terraform destroy..."
               terraform destroy -auto-approve
             else
               echo "Run failed. Please fix it or delete resources manually to avoid audit issues."
               exit 1
             fi
   ```

Notes:
- Do not commit secrets or credentials to this repository.
- Region defaults to `us-east-1`. Update the `provider "aws"` block in `main.tf` if needed.

This repository contains a versioned, private S3 bucket configuration using the community `terraform-aws-modules/s3-bucket/aws` module, alongside an automated, secure GitHub Actions CI/CD engine.

---