include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "kms" {
  config_path = "../kms"
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "lambda" {
  config_path = "../lambda"
  mock_outputs = {
    webhook_handler_lambda_function_url = "https://webhook-handler.lambda.amazonaws.com/2015-03-31/functions/webhook-handler/invocations"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "apigateway" {
  config_path = "../apigateway"
  mock_outputs = {
    apigateway_api_stage_invoke_url = "https://api-id.execute-api.region.amazonaws.com/stage"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  kms_key_arn = include.root.inputs.create_kms_key ? dependency.kms.outputs.kms_key_arn : null
  ssm_parameter_string_parameters = {
    webhook-api-url = dependency.lambda.outputs.webhook_handler_lambda_function_url
    media-api-url   = dependency.apigateway.outputs.apigateway_api_stage_invoke_url
  }
}

terraform {
  source = "${get_repo_root()}/modules/ssm"
}
