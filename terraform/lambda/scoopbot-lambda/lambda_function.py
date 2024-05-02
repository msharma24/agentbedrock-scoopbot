import json
import boto3
import os

# write function to download 2 files from S3 Bucket using boto3 and then save them to /tmp
def download_files_from_s3():
    s3 = boto3.client('s3')
    
    bucket_name = os.environ['BUCKET_NAME']
    key1 = 'key1'
    key2 = 'key2'
    
    s3.download_file(bucket_name, key1, '/tmp/' + key1)
    s3.download_file(bucket_name, key2, '/tmp/' + key2)
    return '/tmp/' + key1, '/tmp/' + key2


def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    response_body = {
        'application/json': {
            'body': "sample response"
        }
    }
    
    action_response = {
        'actionGroup': event['actionGroup'],
        'apiPath': event['apiPath'],
        'httpMethod': event['httpMethod'],
        'httpStatusCode': 200,
        'responseBody': response_body
    }
    
    session_attributes = event['sessionAttributes']
    prompt_session_attributes = event['promptSessionAttributes']
    
    api_response = {
        'messageVersion': '1.0', 
        'response': action_response,
        'sessionAttributes': session_attributes,
        'promptSessionAttributes': prompt_session_attributes
    }
        
    return api_response
