variable "system_name" {
  description = "System name"
  type        = string
  default     = "slc"
}

variable "env_type" {
  description = "Environment type"
  type        = string
  default     = "dev"
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}

variable "webhook_api_url" {
  description = "Webhook API URL to store in Parameter Store"
  type        = string
  default     = null
}

variable "media_api_url" {
  description = "Media API URL to store in Parameter Store"
  type        = string
  default     = null
}

variable "twilio_auth_token" {
  description = "Twilio auth token to store in Parameter Store"
  type        = string
  default     = null
  sensitive   = true
}

variable "ssm_parameter_data_type" {
  description = "Parameter Store data type of parameters"
  type        = string
  default     = "text"
  validation {
    condition     = contains(["text", "aws:ssm:integration", "aws:ec2:image"], var.ssm_parameter_data_type)
    error_message = "SSM Parameter Store data type must be either text, aws:ssm:integration, or aws:ec2:image"
  }
}

variable "ssm_parameter_allowed_pattern" {
  description = "Regular expression used to validate parameter values in Parameter Store"
  type        = string
  default     = null
}

variable "ssm_parameter_tier" {
  description = "Parameter Store tier to assign to parameters"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Advanced", "Intelligent-Tiering"], var.ssm_parameter_tier)
    error_message = "SSM Parameter Store tier must be either Standard, Advanced, or Intelligent-Tiering"
  }
}
