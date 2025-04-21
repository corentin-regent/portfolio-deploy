include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "shared" {
  path = find_in_parent_folders("shared_dependency/terragrunt.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/frontend"
}
