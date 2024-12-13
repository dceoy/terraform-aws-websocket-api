include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "kms" {
  config_path = "../kms"
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "docker" {
  config_path = "../docker"
  mock_outputs = {
    docker_registry_primary_image_uris = {
      connect-handler     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/connect-handler:latest"
      disconnect-handler  = "123456789012.dkr.ecr.us-east-1.amazonaws.com/disconnect-handler:latest"
      sendmessage-handler = "123456789012.dkr.ecr.us-east-1.amazonaws.com/sendmessage-handler:latest"
      default-handler     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/default-handler:latest"
    }
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "dynamodb" {
  config_path = "../dynamodb"
  mock_outputs = {
    connection_dynamodb_table_id = "connection-dynamodb-table-id"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  connect_handler_lambda_image_uri     = dependency.docker.outputs.docker_registry_primary_image_uris["connect-handler"]
  disconnect_handler_lambda_image_uri  = dependency.docker.outputs.docker_registry_primary_image_uris["disconnect-handler"]
  sendmessage_handler_lambda_image_uri = dependency.docker.outputs.docker_registry_primary_image_uris["sendmessage-handler"]
  default_handler_lambda_image_uri     = dependency.docker.outputs.docker_registry_primary_image_uris["default-handler"]
  kms_key_arn                          = include.root.inputs.create_kms_key ? dependency.kms.outputs.kms_key_arn : null
  lambda_environment_variables = {
    CONNECTION_DYNAMODB_TABLE_NAME = dependency.dynamodb.outputs.connection_dynamodb_table_id
  }
}

terraform {
  source = "${get_repo_root()}/modules/lambda"
}
