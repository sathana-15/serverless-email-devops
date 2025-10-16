import json
import os
import urllib.request

def lambda_handler(event, context):
    try:
        body = json.loads(event['body']) if 'body' in event else event

        to_email = body.get('to')
        subject = body.get('subject')
        message = body.get('body')

        if not all([to_email, subject, message]):
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing 'to', 'subject', or 'body' fields"})
            }

        url = "https://api.sendgrid.com/v3/mail/send"
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

        req = urllib.request.Request(url, data=json.dumps(data).encode("utf-8"), headers=headers, method="POST")
        with urllib.request.urlopen(req) as response:
            if response.status == 202:
                return {
                    "statusCode": 200,
                    "body": json.dumps({"message": "✅ Email sent successfully via SendGrid!"})
                }
            else:
                return {
                    "statusCode": response.status,
                    "body": response.read().decode()
                }

    except urllib.error.HTTPError as e:
        return {
            "statusCode": e.code,
            "body": e.read().decode()
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
