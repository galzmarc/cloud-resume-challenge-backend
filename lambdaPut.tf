# Create IAM Role
resource "aws_iam_role" "lambda_put_DynamoDB" {
  name               = "lambda_put_DynamoDB"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Create Lambda function to PUT to DynamoDB
data "archive_file" "python_lambdaPut_package" {
  type        = "zip"
  source_file = "${path.module}/lambda-put-visits.py"
  output_path = "lambda_put.zip"
}

resource "aws_lambda_function" "lambdaPut" {
  function_name    = "lambdaPut"
  filename         = "lambda_put.zip"
  source_code_hash = data.archive_file.python_lambdaPut_package.output_base64sha256
  role             = aws_iam_role.lambda_put_DynamoDB.arn
  runtime          = "python3.10"
  handler          = "lambda-put-visits.lambda_handler"
}

# Attach AmazonDynamoDBFullAccess policy
resource "aws_iam_role_policy_attachment" "dynamodb_full_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.lambda_put_DynamoDB.name
}