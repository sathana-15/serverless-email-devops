variable "lambda_name" {
  description = "Lambda function name"
  default     = "email-notify-lambda-20251015-v2"
}

variable "ses_sender_email" {
  description = "SES verified sender email"
  default     = "sathana.rd2023cse@sece.ac.in"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "ap-south-1"
}
