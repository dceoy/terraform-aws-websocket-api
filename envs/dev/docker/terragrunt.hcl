include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "ecr" {
  config_path = "../ecr"
  mock_outputs = {
    ecr_repository_urls = {
      connect-handler     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/connect-handler"
      disconnect-handler  = "123456789012.dkr.ecr.us-east-1.amazonaws.com/disconnect-handler"
      sendmessage-handler = "123456789012.dkr.ecr.us-east-1.amazonaws.com/sendmessage-handler"
      default-handler     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/default-handler"
    }
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  ecr_repository_urls = dependency.ecr.outputs.ecr_repository_urls
}

terraform {
  source = "${get_repo_root()}/modules/docker"
}
