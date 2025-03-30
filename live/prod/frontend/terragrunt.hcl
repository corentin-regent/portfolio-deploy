include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../modules/frontend"
}

inputs = {
    website_bucket_basename = get_env("TF_VAR_website_bucket_basename")}
}
