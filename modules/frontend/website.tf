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
