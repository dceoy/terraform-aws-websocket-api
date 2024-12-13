data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id                                  = data.aws_caller_identity.current.account_id
  region                                      = data.aws_region.current.name
  connect_handler_lambda_function_name        = split(":", var.connect_handler_lambda_function_qualified_arn)[6]
  connect_handler_lambda_function_version     = length(split(":", var.connect_handler_lambda_function_qualified_arn)) > 7 ? split(":", var.connect_handler_lambda_function_qualified_arn)[7] : "$LATEST"
  disconnect_handler_lambda_function_name     = split(":", var.disconnect_handler_lambda_function_qualified_arn)[6]
  disconnect_handler_lambda_function_version  = length(split(":", var.disconnect_handler_lambda_function_qualified_arn)) > 7 ? split(":", var.disconnect_handler_lambda_function_qualified_arn)[7] : "$LATEST"
  sendmessage_handler_lambda_function_name    = split(":", var.sendmessage_handler_lambda_function_qualified_arn)[6]
  sendmessage_handler_lambda_function_version = length(split(":", var.sendmessage_handler_lambda_function_qualified_arn)) > 7 ? split(":", var.sendmessage_handler_lambda_function_qualified_arn)[7] : "$LATEST"
  default_handler_lambda_function_name        = split(":", var.default_handler_lambda_function_qualified_arn)[6]
  default_handler_lambda_function_version     = length(split(":", var.default_handler_lambda_function_qualified_arn)) > 7 ? split(":", var.default_handler_lambda_function_qualified_arn)[7] : "$LATEST"
}
