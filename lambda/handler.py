import json
import os
import requests

def lambda_handler(event, context):
    try:
        # Parse request body from API Gateway
        body = json.loads(event['body']) if 'body' in event else event

        to_email = body.get('to')
        subject = body.get('subject')
        message = body.get('body')

        if not all([to_email, subject, message]):
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing 'to', 'subject', or 'body' fields"})
            }

        headers = {
            "Authorization": f"Bearer {os.environ['SENDGRID_API_KEY']}",
            "Content-Type": "application/json"
        }

        data = {
            "personalizations": [{"to": [{"email": to_email}]}],
            "from": {"email": os.environ['SES_SENDER_EMAIL']},
            "subject": subject,
            "content": [{"type": "text/plain", "value": message}]
        }

        response = requests.post("https://api.sendgrid.com/v3/mail/send", headers=headers, json=data)

        if response.status_code == 202:
            return {
                "statusCode": 200,
                "body": json.dumps({"message": "✅ Email sent successfully via SendGrid!"})
            }
        else:
            return {
                "statusCode": response.status_code,
                "body": json.dumps({"error": response.text})
            }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
