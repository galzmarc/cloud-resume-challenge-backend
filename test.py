import unittest
from unittest import mock
from lambda_get import lambda_handler

class TestLambdaFunction(unittest.TestCase):
    def test_get_data_from_dynamodb(self):
        # Mocking DynamoDB response
        expected_data = {
            'visits': 42,
        }
        mock_dynamodb_response = {
            'Item': expected_data
        }

        # Patching the DynamoDB resource and table
        with mock.patch('boto3.resource') as mock_resource:
            with mock.patch('boto3.resource.Table') as mock_table:
                # Mocking DynamoDB get_item method
                mock_table.return_value.get_item.return_value = mock_dynamodb_response

                # Calling the Lambda function
                result = lambda_handler(event={}, context={})

                # Assertions
                self.assertEqual(result, expected_data)
                mock_resource.assert_called_once_with('dynamodb')
                mock_table.assert_called_once_with('visitors')
                mock_table.return_value.get_item.assert_called_once_with(Key={'visits': 42})

if __name__ == '__main__':
    unittest.main()
