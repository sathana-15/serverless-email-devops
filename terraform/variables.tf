# ---------------------------
# AWS Region
# ---------------------------
variable "aws_region" {
  description = "AWS Region for deploying resources"
  type        = string
}

# ---------------------------
# SendGrid API Key
# ---------------------------
variable "sendgrid_api_key" {
  description = "SendGrid API key for sending emails"
  type        = string
  sensitive   = true
}

# ---------------------------
# Verified sender email
# ---------------------------
variable "ses_sender_email" {
  description = "Verified sender email for sending emails"
  type        = string
}

# ---------------------------
# Lambda Function Name
# ---------------------------
variable "lambda_name" {
  description = "Unique Lambda function name"
  type        = string
  default     = "sendgrid-lambda-20251016"
}
