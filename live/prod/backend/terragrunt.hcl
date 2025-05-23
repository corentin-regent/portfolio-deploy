include {
  path = "${get_parent_terragrunt_dir()}/live/_common/backend/terragrunt.hcl"
}

inputs = {
  allowed_origins = ["corentin-regent.github.io"]
  environment_variables = {
    SMTP_CLIENT_DOMAIN = "corentin-regent.github.io"
    SMTP_SERVER_DOMAIN = "smtp.gmail.com"
    SMTP_SERVER_PORT = "587"
    SOURCE_EMAIL_ADDRESS = "corentin.regent.bot@gmail.com"
    SOURCE_EMAIL_PASSWORD = get_env("TF_VAR_source_email_password")
    TARGET_EMAIL_ADDRESS = "corentin.regent@gmail.com"
    TIMEOUT_REQUEST_PROCESSING = 5000
  }
}
