variable "cloudfront_logs_folder" {
  type = string
}

variable "environment" {
  type = string
}

variable "lambda_logs_folder" {
  type = string
}

variable "log_retention" {
  type    = number
  default = 30
}

variable "website_access_logs_folder" {
  type = string
}
