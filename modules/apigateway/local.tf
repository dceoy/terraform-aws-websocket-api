data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  lambda_function_qualified_arns = {
    connect-handler    = var.connect_handler_lambda_function_qualified_arn
    disconnect-handler = var.disconnect_handler_lambda_function_qualified_arn
    media-handler      = var.media_handler_lambda_function_qualified_arn
  }
  lambda_function_names = {
    for k, v in local.lambda_function_qualified_arns : k => split(":", v)[6]
  }
  lambda_function_versions = {
    for k, v in local.lambda_function_qualified_arns : k => endswith(v, ":$LATEST") ? null : split(":", v)[7]
  }
}
