import boto3

def lambda_handler(event, context):
    # Create a DynamoDB resource
    dynamodb = boto3.resource('dynamodb')

    try:
        # Get the DynamoDB table
        table = dynamodb.Table('visitors')
        # Retrieve the item from the table
        response = table.get_item(
            Key={
                'id': '1'
            }
        )
        # Extract the item data from the response
        data = response['Item']['visits']
        # Return the item with CORS headers
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',  # Allow requests from any origin
                'Access-Control-Allow-Credentials': True  # Allow credentials (e.g., cookies)
            },
            'body': data
        }
    except Exception as e:
        # Return an error message with CORS headers
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',  # Allow requests from any origin
                'Access-Control-Allow-Credentials': True  # Allow credentials (e.g., cookies)
            },
            'body': str(e)
        }