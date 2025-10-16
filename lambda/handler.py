import json
import os
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    try:
        # Parse request body
        body = json.loads(event['body']) if 'body' in event else event

        to_email = body.get('to')
        subject = body.get('subject')
        message = body.get('body')

        if not all([to_email, subject, message]):
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing 'to', 'subject', or 'body' fields"})
            }

        # Create SES client
        client = boto3.client('ses', region_name=os.environ.get('AWS_REGION', 'ap-south-1'))

        # Send email
        response = client.send_email(
            Source=os.environ['SES_SENDER_EMAIL'],
            Destination={'ToAddresses': [to_email]},
            Message={
                'Subject': {'Data': subject},
                'Body': {'Text': {'Data': message}}
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "✅ Email sent successfully!", "response": response})
        }

    except ClientError as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": e.response['Error']['Message']})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
