import json
import boto3

# Directly set your SES region
ses = boto3.client('ses', region_name='ap-south-1')

def lambda_handler(event, context):
    try:
        # If triggered by API Gateway, body comes as a JSON string
        body = json.loads(event['body']) if 'body' in event else event

        to_address = body['to']
        subject = body['subject']
        body_text = body['body']

        print(f"Sending email to: {to_address}")
        print(f"Subject: {subject}")
        print(f"Body: {body_text}")

        response = ses.send_email(
            Source='sathana.rd2023cse@sece.ac.in',  # Replace with your verified SES sender email
            Destination={'ToAddresses': [to_address]},
            Message={
                'Subject': {'Data': subject},
                'Body': {'Text': {'Data': body_text}}
            }
        )

        print(f"SES Response: {response}")

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Email sent successfully!'})
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
