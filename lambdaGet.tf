# Use IAM Role
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Create Lambda function to GET from DynamoDB
data "archive_file" "python_lambdaGet_package" {
  type        = "zip"
  source_file = "${path.module}/lambda-get-visits.py"
  output_path = "lambda_get.zip"
}

resource "aws_lambda_function" "lambdaGet" {
  function_name    = "lambdaGet"
  filename         = "lambda_get.zip"
  source_code_hash = data.archive_file.python_lambdaGet_package.output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = "python3.10"
  handler          = "lambda-get-visits.lambda_handler"
}

# Attach AmazonDynamoDBReadOnlyAccess policy
resource "aws_iam_role_policy_attachment" "dynamodb_read_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
  role       = aws_iam_role.iam_for_lambda.name
}