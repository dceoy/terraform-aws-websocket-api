resource "aws_ssm_parameter" "string" {
  for_each        = var.ssm_parameter_string_parameters
  name            = "/${var.system_name}/${var.env_type}/${each.key}"
  description     = "String parameter for ${each.key}"
  type            = "String"
  insecure_value  = each.value
  data_type       = var.ssm_parameter_data_type
  allowed_pattern = var.ssm_parameter_allowed_pattern
  tier            = var.ssm_parameter_tier
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/${each.key}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_ssm_parameter" "stringlist" {
  for_each        = var.ssm_parameter_stringlist_parameters
  name            = "/${var.system_name}/${var.env_type}/${each.key}"
  description     = "StringList parameter for ${each.key}"
  type            = "StringList"
  insecure_value  = each.value
  data_type       = var.ssm_parameter_data_type
  allowed_pattern = var.ssm_parameter_allowed_pattern
  tier            = var.ssm_parameter_tier
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/${each.key}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_ssm_parameter" "securestring" {
  for_each        = var.ssm_parameter_securestring_parameters
  name            = "/${var.system_name}/${var.env_type}/${each.key}"
  description     = "SecureString parameter for ${each.key}"
  type            = "SecureString"
  value           = each.value
  data_type       = var.ssm_parameter_data_type
  allowed_pattern = var.ssm_parameter_allowed_pattern
  key_id          = var.kms_key_arn
  tier            = var.ssm_parameter_tier
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/${each.key}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
