dependency "shared" {
  config_path = "../shared"

  mock_outputs = {
    log_bucket_name       = "mock-log-bucket"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}
