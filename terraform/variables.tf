# -----------------------------------
# AWS Region
# -----------------------------------
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

# -----------------------------------
# SendGrid and Sender Email Variables
# -----------------------------------
variable "sendgrid_api_key" {
  description = "SendGrid API key for sending emails securely"
  type        = string
  sensitive   = true
}

variable "ses_sender_email" {
  description = "Verified sender email address used for sending emails"
  type        = string
}

# -----------------------------------
# Lambda Function Name
# -----------------------------------
variable "lambda_name" {
  description = "Unique Lambda function name"
  type        = string
  default     = "sendgrid-lambda-20251016"
}
