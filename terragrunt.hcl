remote_state {
  backend = "s3"

  config = {
    bucket         = "${get_env("TF_VAR_state_bucket_basename")}-${var.environment}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = get_env("AWS_REGION")
    encrypt        = true
    dynamodb_table = "${get_env("TF_VAR_state_table_basename")}-${var.environment}"
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
  environment  = regex(".*/live/(?P<env>.*?)/.*", get_terragrunt_dir()).env
}
