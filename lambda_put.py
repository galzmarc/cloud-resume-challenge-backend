import boto3

def lambda_handler(event, context):
    # Get the DynamoDB resource
    dynamodb = boto3.resource('dynamodb')
    # Get the DynamoDB table
    table = dynamodb.Table('visitors')
    # Get the key of the item to be modified
    item_key = {
        'id': '1'
    }
    # Update the "visits" attribute by incrementing its value by 1
    update_expression = 'SET visits = visits + :val'
    expression_attribute_values = {
        ':val': 1
    }

    try:
        # Update the item in DynamoDB
        table.update_item(
            Key=item_key,
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values
        )

        return {
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
            },
            'statusCode': 200,
            'body': 'Item updated successfully'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error updating item in DynamoDB: {str(e)}'
}