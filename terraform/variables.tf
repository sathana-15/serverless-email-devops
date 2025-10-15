variable "aws_region" {
  default = "ap-south-1"
}

variable "lambda_name" {
  default = "email-notify-lambda-v6" # Match the Lambda function unique name
}

variable "ses_sender_email" {
  default = "sathana.rd2023cse@sece.ac.in"  # Replace with your verified SES email
}
