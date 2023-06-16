# Create DynamoDB table
resource "aws_dynamodb_table" "dynamodb_table_visitors" {
  name         = "visitors"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Initialize visits attribute at 0
resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.dynamodb_table_visitors.name
  hash_key   = aws_dynamodb_table.dynamodb_table_visitors.hash_key

  item = jsonencode(
    {
      "id" : { "S" : "1" },
      "visits" : { "N" : "0" },
    }
  )
}