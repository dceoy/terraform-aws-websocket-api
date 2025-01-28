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
    "media-handler",
    "webhook-handler"
  ]
}

target "connect-handler" {
  tags       = ["${REGISTRY}/ws-connect-handler:${TAG}"]
  context    = "./src"
  dockerfile = "connect_handler/Dockerfile"
  target     = "app"
  platforms  = ["linux/arm64"]
  args = {
    PYTHON_VERSION = PYTHON_VERSION
    USER_UID       = USER_UID
    USER_GID       = USER_GID
    USER_NAME      = USER_NAME
  }
  cache_from = ["type=gha"]
  cache_to   = ["type=gha,mode=max"]
  pull       = true
  push       = false
  load       = true
  provenance = false
}

target "disconnect-handler" {
  tags       = ["${REGISTRY}/ws-disconnect-handler:${TAG}"]
  context    = "./src"
  dockerfile = "disconnect_handler/Dockerfile"
  target     = "app"
  platforms  = ["linux/arm64"]
  args = {
    PYTHON_VERSION = PYTHON_VERSION
    USER_UID       = USER_UID
    USER_GID       = USER_GID
    USER_NAME      = USER_NAME
  }
  cache_from = ["type=gha"]
  cache_to   = ["type=gha,mode=max"]
  pull       = true
  push       = false
  load       = true
  provenance = false
}

target "media-handler" {
  tags       = ["${REGISTRY}/ws-media-handler:${TAG}"]
  context    = "./src"
  dockerfile = "media_handler/Dockerfile"
  target     = "app"
  platforms  = ["linux/arm64"]
  args = {
    PYTHON_VERSION = PYTHON_VERSION
    USER_UID       = USER_UID
    USER_GID       = USER_GID
    USER_NAME      = USER_NAME
  }
  cache_from = ["type=gha"]
  cache_to   = ["type=gha,mode=max"]
  pull       = true
  push       = false
  load       = true
  provenance = false
}

target "webhook-handler" {
  tags       = ["${REGISTRY}/ws-webhook-handler:${TAG}"]
  context    = "./src"
  dockerfile = "webhook_handler/Dockerfile"
  target     = "app"
  platforms  = ["linux/arm64"]
  args = {
    PYTHON_VERSION = PYTHON_VERSION
    USER_UID       = USER_UID
    USER_GID       = USER_GID
    USER_NAME      = USER_NAME
  }
  cache_from = ["type=gha"]
  cache_to   = ["type=gha,mode=max"]
  pull       = true
  push       = false
  load       = true
  provenance = false
}
