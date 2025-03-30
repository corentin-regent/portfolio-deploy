variable "allowed_origins" {
  type = array(string)
}

variable "cloudwatch_log_retention" {
  type    = number
  default = 30
}

variable "cors_max_age" {
  type    = number
  default = 86400
}

variable "default_route_settings" {
  type = object({
    data_trace_enabled       = optional(bool, true)
    detailed_metrics_enabled = optional(bool, true)
    logging_level            = optional(string)
    throttling_burst_limit   = optional(number, 10)
    throttling_rate_limit    = optional(number, 10)
  })
}

variable "email_timeout" {
  type    = number
  default = 5000
}

variable "environment" {
  type = string
}

variable "environment_variables" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "executable" {
  type = string
}
