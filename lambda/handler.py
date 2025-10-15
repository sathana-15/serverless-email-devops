import json
import boto3
import os

ses = boto3.client('ses')

def lambda_handler(event, context):
    try:
        # If triggered by API Gateway, the body comes as a JSON string
        body = json.loads(event['body']) if 'body' in event else event

        to_address = body['to']
        subject = body['subject']
        body_text = body['body']

        response = ses.send_email(
            Source=os.environ['SES_SENDER_EMAIL'],
            Destination={'ToAddresses': [to_address]},
            Message={
                'Subject': {'Data': subject},
                'Body': {'Text': {'Data': body_text}}
            }
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Email sent successfully!'})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
