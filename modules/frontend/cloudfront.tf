module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 4"

  is_ipv6_enabled = true
  http_version    = "http2and3"

  price_class = var.environment == "prod" ? "PriceClass_All" : "PriceClass_100"

  default_root_object = "index.html"

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    s3_website = {
      domain_name           = module.website_bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control = "s3_oac"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "portfolio-front-${module.website_bucket.s3_bucket_id}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
  }

  logging_config = {
    bucket          = aws_s3_bucket.logs_bucket.bucket_domain_name
    prefix          = var.cloudfront_logs_folder
    include_cookies = false
  }
}
