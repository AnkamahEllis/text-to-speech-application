resource "aws_iam_role" "lambda_exec" {
  name = "tts-lambda-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid     = "AllowPolly"
    effect  = "Allow"
    actions = ["polly:SynthesizeSpeech"]
    resources = ["*"]
  }

  statement {
    sid     = "S3PutGet"
    effect  = "Allow"
    actions = ["s3:PutObject", "s3:GetObject", "s3:PutObjectAcl"]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }

  statement {
    sid     = "Logs"
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "tts-lambda-policy"
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "./lambda"
  output_path = "./lambda/lambda.zip"
}

resource "aws_lambda_function" "this" {
  function_name = "tts-terraform-function"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
      REGION      = var.aws_region
    }
  }
}
