include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/dceoy/terraform-aws-crud-http-api.git//modules/kms?ref=main"
}
