terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
  profile = "george"
}

## LAMBDA STORAGE

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "lambda_archive" {
  type = "zip"
  source_dir  = "${path.module}/../api"
  output_path = "${path.module}/../api.zip"
}

resource "aws_s3_object" "geDOTorg-lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "api.zip"
  source = data.archive_file.lambda_archive.output_path

  etag = filemd5(data.archive_file.lambda_archive.output_path)
}


## FRONTEND STORAGE

resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.bucket_name}-frontend"
}

resource "aws_s3_bucket_website_configuration" "website_bucket_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "website_ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_access_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_bucket" {
    bucket = aws_s3_bucket.website_bucket.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
          "${aws_s3_bucket.website_bucket.arn}",
          "${aws_s3_bucket.website_bucket.arn}/*"
        ]
      },
    ]
  })
}

# LAMBDA

resource "aws_lambda_function" "geDOTorg_lambda_func" {
  function_name = "geDOTorg-api"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.geDOTorg-lambda.key

  runtime = "nodejs18.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_archive.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "geDOTorg_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.geDOTorg_lambda_func.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamoroles" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# GATEWAY

resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "geDOTorg_gateway" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.geDOTorg_lambda_func .invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "route" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.geDOTorg_gateway.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.geDOTorg_lambda_func.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

# DYNAMODB

resource "aws_dynamodb_table" "counter" {
 name = "counter"
 billing_mode = "PROVISIONED"
 read_capacity= "30"
 write_capacity= "30"
 attribute {
  name = "count"
  type = "N"
 }
 hash_key = "count"
}