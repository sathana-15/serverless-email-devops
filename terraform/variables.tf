variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ses_sender_email" {
  type    = string
  default = "sathana.rd2023cse@sece.ac.in"
}

# Unique names to avoid conflicts
variable "lambda_name" {
  type    = string
  default = "email-notify-lambda-20251015"
}

variable "lambda_role_name" {
  type    = string
  default = "lambda-ses-role-20251015"
}

variable "ses_policy_name" {
  type    = string
  default = "lambda-ses-send-policy-20251015"
}

variable "lambda_handler" {
  type    = string
  default = "handler.lambda_handler"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.11"
}
