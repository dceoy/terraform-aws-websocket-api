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

variable "ssm_parameter_string_parameters" {
  description = "String parameters for Parameter Store (key: key, value: value)"
  type        = map(string)
  default     = {}
}

variable "ssm_parameter_stringlist_parameters" {
  description = "StringList parameters for Parameter Store (key: key, value: value)"
  type        = map(string)
  default     = {}
}

variable "ssm_parameter_securestring_parameters" {
  description = "SecureString parameters for Parameter Store (key: key, value: value)"
  type        = map(string)
  default     = {}
  # ephemeral   = true
  # sensitive   = true
}

variable "ssm_parameter_data_type" {
  description = "Parameter Store data type of parameters"
  type        = string
  default     = null
  validation {
    condition     = var.ssm_parameter_data_type == null || contains(["text", "aws:ssm:integration", "aws:ec2:image"], var.ssm_parameter_data_type)
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
  default     = null
  validation {
    condition     = var.ssm_parameter_tier == null || contains(["Standard", "Advanced", "Intelligent-Tiering"], var.ssm_parameter_tier)
    error_message = "SSM Parameter Store tier must be either Standard, Advanced, or Intelligent-Tiering"
  }
}
