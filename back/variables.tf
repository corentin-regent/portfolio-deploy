variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "cloudwatch_log_retention" {
  type    = number
  default = 0
}

variable "executable" {
  type = string
}
