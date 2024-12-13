variable "ecr_repository_urls" {
  description = "ECR repository URLs"
  type        = map(string)
  default     = {}
}

variable "ecr_image_secondary_tags" {
  description = "ECR image secondary tags"
  type        = list(string)
  default     = []
}

variable "docker_image_force_remove" {
  description = "Whether to remove the image forcibly when the resource is destroyed"
  type        = bool
  default     = false
}

variable "docker_image_build" {
  description = "Whether to build the Docker image"
  type        = bool
  default     = true
}

variable "docker_image_build_targets" {
  description = "Docker image build target stages"
  type        = map(string)
  default     = {}
}

variable "docker_image_build_context" {
  description = "Docker image build context"
  type        = string
  default     = "."
}

variable "docker_image_build_dockerfile" {
  description = "Dockerfile name"
  type        = string
  default     = "Dockerfile"
}

variable "docker_image_build_build_args" {
  description = "Docker image build-time variables"
  type        = map(string)
  default     = {}
}

variable "docker_image_build_platform" {
  description = "Docker image platform"
  type        = string
  default     = null
}

variable "docker_image_primary_tag" {
  description = "Docker image primary tag"
  type        = string
  default     = "latest"
}

variable "docker_host" {
  description = "Docker daemon address"
  type        = string
  default     = "unix:///var/run/docker.sock"
}
