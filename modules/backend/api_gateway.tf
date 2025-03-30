module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "portfolio-back-gateway-${var.environment}"
  description   = "HTTP API Gateway for Portfolio backend"
  protocol_type = "HTTP"

  fail_on_warnings = true

  cors_configuration = {
    allow_credentials = false
    allow_headers     = ["Content-Type"]
    allow_methods     = ["POST"]
    allow_origins     = var.allowed_origins
    max_age           = var.cors_max_age
  }

  routes = {
    "POST /api/email" = {
      timeout_milliseconds = var.email_timeout
      integration = {
        uri                    = module.lambda.lambda_function_arn
        payload_format_version = "2.0"
      }
    }
  }

  stage_default_route_settings = var.default_route_settings
}
