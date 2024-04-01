data "aws_s3_bucket" "storage_bucket"{
  bucket = var.storage_bucket
}

resource "aws_lambda_function" "catcounter_lambda_func" {
  function_name = var.function_name

  s3_bucket = data.aws_s3_bucket.storage_bucket.id
  s3_key    = var.storage_key

  runtime = "nodejs18.x"
  handler = "server.handler"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "catcounter_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.catcounter_lambda_func.function_name}"

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