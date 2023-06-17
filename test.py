import unittest
from unittest import mock
from unittest.mock import Mock
from lambda_get import lambda_handler

class TestLambdaFunction(unittest.TestCase):
    def test_get_data_from_dynamodb(self):

        # Mocking DynamoDB table
        mock_table = Mock()
        
        # Mocking DynamoDB response
        mock_dynamodb_response = {'Item': {'visits': 42}}
        
        with mock.patch('boto3.resource') as mock_resource:
            with mock.patch('boto3.resource.Table') as mock_table:

                # Mocking DynamoDB get_item method
                mock_table.get_item.return_value = mock_dynamodb_response 
        
                # Calling the Lambda function
                result = lambda_handler(event={}, context={})
                
                # Assertions
                self.assertEqual(result['statusCode'], 200)
                mock_resource.assert_called_once_with('dynamodb')

if __name__ == '__main__':
    unittest.main()
