resource "aws_apigatewayv2_api" "this" {
  name          = "tts-terraform-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["http://ab3-text-to-speech-tf.s3-website-us-east-1.amazonaws.com"]
    allow_methods = ["OPTIONS", "POST"]
    allow_headers = ["content-type"]
  }
}



resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.lambda_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "synthesize" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /synthesize"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}
