variable "AWS_ACCOUNT_ID" {
  default = null
}

variable "AWS_REGION" {
  default = null
}

variable "AMAZON_ECR_REGISTRY_URL" {
  default = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
}

variable "TAG" {
  default = "latest"
}

group "default" {
  targets = [
    "connect-handler",
    "disconnect-handler",
    "default-handler",
    "sendmessage-handler"
  ]
}

target "connect-handler" {
  tags       = ["${AMAZON_ECR_REGISTRY_URL}/connect-handler:${TAG}"]
  context    = "./src/connect_handler"
  dockerfile = "Dockerfile"
  target     = "app"
  platforms  = ["linux/arm64"]
  cache_from = ["type=gha"]
  cache_to   = ["type=gha,mode=max"]
  pull       = true
  push       = false
  load       = true
  provenance = false
}

target "disconnect-handler" {
  tags       = ["${AMAZON_ECR_REGISTRY_URL}/disconnect-handler:${TAG}"]
  context    = "./src/disconnect_handler"
  dockerfile = "Dockerfile"
  target     = "app"
  platforms  = ["linux/arm64"]
  cache_from = ["type=gha"]
  cache_to   = ["type=gha,mode=max"]
  pull       = true
  push       = false
  load       = true
  provenance = false
}

target "default-handler" {
  tags       = ["${AMAZON_ECR_REGISTRY_URL}/default-handler:${TAG}"]
  context    = "./src/default_handler"
  dockerfile = "Dockerfile"
  target     = "app"
  platforms  = ["linux/arm64"]
  cache_from = ["type=gha"]
  cache_to   = ["type=gha,mode=max"]
  pull       = true
  push       = false
  load       = true
  provenance = false
}

target "sendmessage-handler" {
  tags       = ["${AMAZON_ECR_REGISTRY_URL}/sendmessage-handler:${TAG}"]
  context    = "./src/sendmessage_handler"
  dockerfile = "Dockerfile"
  target     = "app"
  platforms  = ["linux/arm64"]
  cache_from = ["type=gha"]
  cache_to   = ["type=gha,mode=max"]
  pull       = true
  push       = false
  load       = true
  provenance = false
}
