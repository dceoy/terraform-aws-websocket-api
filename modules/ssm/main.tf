resource "aws_ssm_parameter" "webhook" {
  name            = "/${var.system_name}/${var.env_type}/webhook-api-url"
  description     = "String parameter for the webhook API URL"
  type            = "String"
  insecure_value  = var.webhook_api_url
  data_type       = var.ssm_parameter_data_type
  allowed_pattern = var.ssm_parameter_allowed_pattern
  tier            = var.ssm_parameter_tier
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/webhook-api-url"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_ssm_parameter" "media" {
  name            = "/${var.system_name}/${var.env_type}/media-api-url"
  description     = "String parameter for the media API URL"
  type            = "String"
  insecure_value  = var.media_api_url
  data_type       = var.ssm_parameter_data_type
  allowed_pattern = var.ssm_parameter_allowed_pattern
  tier            = var.ssm_parameter_tier
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/media-api-url"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_ssm_parameter" "twilio" {
  name            = "/${var.system_name}/${var.env_type}/twilio-auth-token"
  description     = "SecureString parameter for Twilio auth token"
  type            = "SecureString"
  value           = var.twilio_auth_token
  data_type       = var.ssm_parameter_data_type
  allowed_pattern = var.ssm_parameter_allowed_pattern
  key_id          = var.kms_key_arn
  tier            = var.ssm_parameter_tier
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/twilio-auth-token"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
