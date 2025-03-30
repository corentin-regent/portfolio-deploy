module "lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "portfolio-back-lambda-${var.environment}"
  description   = "HTTP Server for Portfolio website backend"

  source_path   = var.executable
  handler       = "main"
  runtime       = "go1.x"
  architectures = ["arm64"]

  cloudwatch_logs_retention_in_days = var.cloudwatch_log_retention
  tracing_mode                      = "Active"

  environment_variables = var.environment_variables

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }
}
