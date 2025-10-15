variable "aws_region" {
  default = "ap-south-1"
}

variable "lambda_name" {
  default = "email-notify-lambda"
}

variable "ses_sender_email" {
  default = "youremail@gmail.com"  # Replace with your verified SES email
}
