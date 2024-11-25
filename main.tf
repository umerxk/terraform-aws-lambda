# AWS Provider
provider "aws" {
  region = "" //your region
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "go_lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for CloudWatch Logs
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_logging_policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "go_lambda" {
  function_name = "your_lambda_function_name"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "provided.al2"

  filename         = "${path.module}/lambda_function.zip" // Path to the Lambda function
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  # VPC configuration
  vpc_config {
    subnet_ids         = [""] // your subnet id
    security_group_ids = [""] // your security group id
  }

  # Timeout Setting (3 minutes = 180 seconds)
  timeout = 180
}

# CloudWatch EventBridge Rule for periodic execution (every 5 minutes)
resource "aws_cloudwatch_event_rule" "lambda_trigger" {
  name                = "lambda_every_seven_minutes"
  schedule_expression = "cron(0/7 * * * ? *)"
}

# Permission for EventBridge to invoke the Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.go_lambda.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_trigger.arn
}

# EventBridge Target to trigger Lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_trigger.name
  target_id = "GoLambdaTarget"
  arn       = aws_lambda_function.go_lambda.arn
}
