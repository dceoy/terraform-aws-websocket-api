output "ssm_parameter_webhook_api_url_parameter_name" {
  description = "Parameter Store parameter name for the webhook API URL"
  value       = aws_ssm_parameter.webhook.name
}

output "ssm_parameter_media_api_url_parameter_name" {
  description = "Parameter Store parameter name for the media API URL"
  value       = aws_ssm_parameter.media.name
}

output "ssm_parameter_twilio_auth_token_parameter_name" {
  description = "Parameter Store parameter name for Twilio auth token"
  value       = aws_ssm_parameter.twilio.name
}
