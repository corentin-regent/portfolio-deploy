module "website_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4"

  bucket = "portfolio-front-${var.environment}-${random_pet.website_bucket_suffix.id}"
  acl    = "private"

  website = {
    index_document = "index.html"
    error_document = "404.html"
  }

  versioning = {
    enabled = true
  }

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  logging = {
    target_bucket = var.log_bucket_name
    target_prefix = var.website_access_logs_folder
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.website_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

resource "terraform_data" "upload_static_files" {
  provisioner "local-exec" {
    command = "aws s3 sync ${var.static_files} s3://${aws_s3_bucket.site.bucket} --delete"
  }

  triggers_replace = {
    always = timestamp()
  }
}

resource "random_pet" "website_bucket_suffix" {}
