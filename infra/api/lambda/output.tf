output "lambda_function_name"{
    description = "Name of the lambda function."
    value = aws_lambda_function.catcounter_lambda_func.function_name
}