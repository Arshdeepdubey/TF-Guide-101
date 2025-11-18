terraform {
    required_version = ">= 1.3.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

# Get current AWS account information
data "aws_caller_identity" "current" {}

module "s3_bucket" {
    source = "terraform-aws-modules/s3-bucket/aws"

    create_bucket = true
    bucket        = "arshdeep-s3-bucket"

    control_object_ownership = true
    object_ownership          = "BucketOwnerEnforced"

    # Strongly recommended: block all forms of public access
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true

    versioning = {
        enabled = true
    }
}

resource "aws_s3_bucket_policy" "read_only_for_role" {
    bucket = module.s3_bucket.s3_bucket_id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "ReadOnlyRole"
                Effect = "Allow"
                Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
                Action = ["s3:GetObject", "s3:ListBucket", "s3:PutObject"]
                Resource = [
                    "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}",
                    "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}/*"
                ]
            }
        ]
    })
}