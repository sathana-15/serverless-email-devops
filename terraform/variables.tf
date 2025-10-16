# variables.tf

variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
}

variable "sendgrid_api_key" {
  description = "SendGrid API key for sending emails securely"
  type        = string
  sensitive   = true
}

variable "ses_sender_email" {
  description = "Verified sender email address used for sending emails via SendGrid"
  type        = string
}

variable "lambda_name" {
  description = "Unique Lambda function name"
  type        = string
  default     = "sendgrid-lambda-20251018"  # change suffix if needed
}
