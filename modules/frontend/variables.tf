variable "environment" {
  type = string
}

variable "website_bucket_basename" {
  type      = string
  sensitive = true
}
