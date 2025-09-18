variable "bucket_name" {
  type        = string
  description = "S3 bucket for audio output"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "lambda_source_dir" {
  type        = string
  description = "Path to Lambda source code"
}
