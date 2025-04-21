module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4"

  bucket           = "logs-portfolio-front-${var.environment}-${random_pet.log_bucket_suffix.id}"
  force_destroy    = var.environment != "prod"
  object_ownership = "BucketOwnerPreferred"

  lifecycle_rule = [
    {
      id      = "log-retention"
      enabled = true
      expiration = {
        days = var.log_retention
      }
    }
  ]
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = module.log_bucket.s3_bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ServerAccessLogsPolicy"
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${module.log_bucket.s3_bucket_arn}/s3-access-logs/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid    = "CloudFrontLogsPolicy"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "s3:PutObject"
        Resource = "${module.log_bucket.s3_bucket_arn}/cloudfront-logs/*"
      },
      {
        Sid    = "LambdaLogsPolicy"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${module.log_bucket.s3_bucket_arn}/lambda-logs/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

resource "random_pet" "log_bucket_suffix" {}

data "aws_caller_identity" "current" {}
