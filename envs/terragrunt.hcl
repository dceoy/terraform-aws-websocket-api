locals {
  image_name = "web"
  repo_root  = get_repo_root()
  env_vars   = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  docker_image_build_platforms = {
    "X86_64" = "linux/amd64"
    "ARM64"  = "linux/arm64"
  }
}

terraform {
  extra_arguments "parallelism" {
    commands = get_terraform_commands_that_need_parallelism()
    arguments = [
      "-parallelism=16"
    ]
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = local.env_vars.locals.terraform_s3_bucket
    key            = "${basename(local.repo_root)}/${local.env_vars.locals.system_name}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.env_vars.locals.region
    encrypt        = true
    dynamodb_table = local.env_vars.locals.terraform_dynamodb_table
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.env_vars.locals.region}"
  default_tags {
    tags = {
      SystemName = "${local.env_vars.locals.system_name}"
      EnvType    = "${local.env_vars.locals.env_type}"
    }
  }
}
EOF
}

catalog {
  urls = [
    "github.com/dceoy/terraform-aws-docker-based-lambda"
  ]
}

inputs = {
  system_name                      = local.env_vars.locals.system_name
  env_type                         = local.env_vars.locals.env_type
  ecr_repository_name              = local.image_name
  ecr_image_secondary_tags         = compact(split(",", get_env("DOCKER_METADATA_OUTPUT_TAGS", "latest")))
  ecr_image_tag_mutability         = "MUTABLE"
  ecr_force_delete                 = true
  ecr_lifecycle_policy_image_count = 1
  docker_image_force_remove        = true
  docker_image_build               = local.env_vars.locals.docker_image_build
  docker_image_build_context       = "${local.repo_root}/docker"
  docker_image_build_dockerfile    = "Dockerfile"
  docker_image_build_build_args    = {}
  docker_image_build_platform      = local.docker_image_build_platforms[local.batch_cpu_architecture]
  docker_image_primary_tag         = get_env("DOCKER_PRIMARY_TAG", run_cmd("--terragrunt-quiet", "git", "rev-parse", "--short", "HEAD"))
  docker_host                      = get_env("DOCKER_HOST", "unix:///var/run/docker.sock")
}
