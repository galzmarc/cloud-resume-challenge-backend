# Create the API Gateway
resource "aws_api_gateway_rest_api" "visitorsCounter" {
  name        = "visitorsCounter"
  description = "API for the Cloud Resume Challenge"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# GET method
resource "aws_api_gateway_method" "methodGet" {
  rest_api_id   = aws_api_gateway_rest_api.visitorsCounter.id
  resource_id   = aws_api_gateway_rest_api.visitorsCounter.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integrationGet" {
  rest_api_id             = aws_api_gateway_rest_api.visitorsCounter.id
  resource_id             = aws_api_gateway_rest_api.visitorsCounter.root_resource_id
  http_method             = aws_api_gateway_method.methodGet.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambdaGet.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdaGet.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:${var.account_id}:${aws_api_gateway_rest_api.visitorsCounter.id}/*/${aws_api_gateway_method.methodGet.http_method}/"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id     = aws_api_gateway_rest_api.visitorsCounter.id
  resource_id     = aws_api_gateway_rest_api.visitorsCounter.root_resource_id
  http_method     = aws_api_gateway_method.methodGet.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# PUT method
resource "aws_api_gateway_method" "methodPut" {
  rest_api_id   = aws_api_gateway_rest_api.visitorsCounter.id
  resource_id   = aws_api_gateway_rest_api.visitorsCounter.root_resource_id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integrationPut" {
  rest_api_id             = aws_api_gateway_rest_api.visitorsCounter.id
  resource_id             = aws_api_gateway_rest_api.visitorsCounter.root_resource_id
  http_method             = aws_api_gateway_method.methodPut.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambdaPut.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_put" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdaPut.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:${var.account_id}:${aws_api_gateway_rest_api.visitorsCounter.id}/*/${aws_api_gateway_method.methodPut.http_method}/"
}

resource "aws_api_gateway_deployment" "test_deployment" {
  depends_on  = [aws_api_gateway_integration.integrationGet, aws_api_gateway_integration.integrationPut]
  rest_api_id = aws_api_gateway_rest_api.visitorsCounter.id
  stage_name  = "dev"
  variables = {
    deployed_at = "${timestamp()}"
  }
}

# Output the endpoint of the API, to be used in the frontend
output "endpoint" {
  value = aws_api_gateway_deployment.test_deployment.invoke_url
}