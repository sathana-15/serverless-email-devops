# ---------------------------
# IAM Role for Lambda
# ---------------------------
resource "aws_iam_role" "lambda_role" {
  name = "lambda-sendgrid-role-20251016"  # Unique role name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = { Service = "lambda.amazonaws.com" },
      Effect    = "Allow",
      Sid       = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ---------------------------
# Zip Lambda code
# ---------------------------
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../lambda"
  output_path = "../terraform/lambda.zip"
}

# ---------------------------
# Lambda function
# ---------------------------
resource "aws_lambda_function" "send_email" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = var.lambda_name  # Unique Lambda name from variables.tf
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"

  environment {
    variables = {
      SENDGRID_API_KEY = var.sendgrid_api_key
      SES_SENDER_EMAIL = var.ses_sender_email
    }
  }

  timeout = 15
}

# ---------------------------
# API Gateway HTTP API
# ---------------------------
resource "aws_apigatewayv2_api" "api" {
  name          = "sendgrid-api-20251016"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.send_email.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /send"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

# ---------------------------
# Lambda permission for API Gateway
# ---------------------------
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
