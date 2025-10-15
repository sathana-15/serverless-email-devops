import boto3
import os

def lambda_handler(event, context):
    ses_client = boto3.client('ses', region_name=os.environ['AWS_REGION'])
    response = ses_client.send_email(
        Source=os.environ['SES_SENDER_EMAIL'],
        Destination={'ToAddresses': [event['to']]},
        Message={
            'Subject': {'Data': event['subject']},
            'Body': {'Text': {'Data': event['body']}}
        }
    )
    return {'status': 'Email sent', 'response': str(response)}
