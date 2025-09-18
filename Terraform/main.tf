terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

# S3 Bucket (Frontend + Audio)
module "s3" {
  source      = "./modules/s3"
  bucket_name = "ab3-text-to-speech-tf"
}

# Lambda function
module "lambda" {
  source            = "./modules/lambda"
  bucket_name       = module.s3.bucket_name
  aws_region        = "us-east-1"
  lambda_source_dir = "./lambda/lambda.zip"
}

# API Gateway
module "api" {
  source     = "./modules/api"
  lambda_arn = module.lambda.lambda_arn
}
