# ---------------------------
# Provider
# ---------------------------
provider "aws" {
  region = var.aws_region
}

# ---------------------------
# IAM Role for Lambda
# ---------------------------
resource "aws_iam_role" "lambda_role" {
  name = "lambda-sendgrid-role-20251017"  # unique role name
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

# SendGrid/SES send policy
resource "aws_iam_policy" "sendgrid_policy" {
  name   = "lambda-sendgrid-policy-20251017"  # unique
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["ses:SendEmail", "ses:SendRawEmail"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_sendgrid" {
  name       = "attach-sendgrid-policy-20251017" # unique
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.sendgrid_policy.arn
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
resource "aws_lambda_function" "email_lambda" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = var.lambda_name
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
  name          = "sendgrid-api-20251017"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.email_lambda.arn
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
  function_name = aws_lambda_function.email_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
