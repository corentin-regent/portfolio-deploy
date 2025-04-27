remote_state {
  backend = "s3"

  config = {
    bucket         = "portfolio-tfstate-${get_aws_account_id()}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = get_env("AWS_REGION")
    encrypt        = true
    dynamodb_table = "portfolio-locks-${get_aws_account_id()}"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  default_tags {
    tags = {
      Environment = var.environment
      Project = "Portfolio"
    }
  }
}
EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "~> 1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}
EOF
}

inputs = {
  environment                = regex(".*/live/(?P<env>.*?)/.*", get_terragrunt_dir()).env

  cloudfront_logs_folder     = "cloudfront-logs"
  lambda_logs_folder         = "lambda-logs"
  website_access_logs_folder = "website-access-logs"
}
