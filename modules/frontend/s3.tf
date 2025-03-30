module "s3" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.website_bucket_basename}-${var.environment}"

  website = {
    index_document = "index.html"
    error_document = "404.html"
  }

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
