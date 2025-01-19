variable "REGISTRY" {
  default = "123456789012.dkr.ecr.us-east-1.amazonaws.com"
}

variable "TAG" {
  default = "latest"
}

variable "PYTHON_VERSION" {
  default = "3.13"
}

variable "USER_UID" {
  default = 1001
}

variable "USER_GID" {
  default = 1001
}

variable "USER_NAME" {
  default = "lambda"
}

group "default" {
  targets = [
    "connect-handler",
    "disconnect-handler",
    "sendmessage-handler",
    "webhook-handler"
  ]
}

target "connect-handler" {
  tags       = ["${REGISTRY}/ws-connect-handler:${TAG}"]
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
  tags       = ["${REGISTRY}/ws-disconnect-handler:${TAG}"]
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

target "sendmessage-handler" {
  tags       = ["${REGISTRY}/ws-sendmessage-handler:${TAG}"]
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

target "webhook-handler" {
  tags       = ["${REGISTRY}/ws-webhook-handler:${TAG}"]
  context    = "./src/webhook_handler"
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
