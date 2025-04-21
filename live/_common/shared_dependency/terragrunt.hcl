dependency "shared" {
  config_path = "../shared"

  mock_outputs = {
    log_bucket_name       = "mock-log-bucket"
    log_bucket_arn        = "arn:aws:s3:::mock-log-bucket"
    log_bucket_domain_name = "mock-log-bucket.s3.amazonaws.com"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}
