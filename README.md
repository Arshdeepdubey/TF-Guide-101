# Terraform AWS S3 Example

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

Notes:
- Do not commit secrets or credentials to this repository.
- Region defaults to `us-east-1`. Update the `provider "aws"` block in `main.tf` if needed.