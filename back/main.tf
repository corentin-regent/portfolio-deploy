provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "Portfolio"
    }
  }
}

module "lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "portfolio-back-lambda"
  description   = "HTTP Server for Portfolio website backend"

  source_path   = var.executable
  handler       = "main"
  runtime       = "go1.x"
  architectures = ["arm64"]

  cloudwatch_logs_retention_in_days = var.cloudwatch_log_retention
  tracing_mode                      = "Active"

  environment_variables = {
    # TODO
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }
}

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name        = "portfolio-back-gateway"
  description = "HTTP API Gateway for Portfolio backend"

  fail_on_warnings = true

  cors_configuration = {
    allow_credentials = false
    allow_headers     = ["Content-Type"]
    allow_methods     = ["POST"]
    allow_origins     = ["corentin-regent.github.io"]
    max_age           = 86400
  }

  routes = {
    "POST /api/email" = {
      data_trace_enabled       = true
      detailed_metrics_enabled = true
      throttling_rate_limit    = 10
      throttling_burst_limit   = 10
      timeout_milliseconds     = 5000

      integration = {
        uri                    = module.lambda.lambda_function_arn
        payload_format_version = "2.0"
      }
    }
  }
}

resource "aws_wafv2_web_acl" "waf" {
  name  = "portfolio-back-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "block-large-requests"
    priority = 1

    statement {
      size_constraint_statement {
        field_to_match {
          body {}
        }
        comparison_operator = "GT"
        size                = 65536
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    action {
      block {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockLargeRequests"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "PortfolioBackWaf"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "gateway_waf_assoc" {
  resource_arn = module.api_gateway.apigatewayv2_api_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

resource "aws_cloudwatch_log_group" "waf_log_group" {
  name              = "aws-waf-logs-portfolio-back"
  retention_in_days = var.cloudwatch_log_retention
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_log_config" {
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
  resource_arn            = aws_wafv2_web_acl.main.arn
}
