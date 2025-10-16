# -----------------------------------
# AWS Region
# -----------------------------------
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

# -----------------------------------
# SendGrid API Key
# -----------------------------------
variable "sendgrid_api_key" {
  description = "SendGrid API key for sending emails securely"
  type        = string
  sensitive   = true
}

# -----------------------------------
# Verified sender email
# -----------------------------------
variable "ses_sender_email" {
  description = "Verified sender email address used for sending emails"
  type        = string
}

# -----------------------------------
# Lambda function name
# -----------------------------------
variable "lambda_name" {
  description = "Unique Lambda function name"
  type        = string
  default     = "sendgrid-lambda-20251016"
}
