output "ssm_parameter_string_parameter_names" {
  description = "Parameter Store string parameter names"
  value       = { for k, v in aws_ssm_parameter.string : k => v.name }
}

output "ssm_parameter_stringlist_parameter_names" {
  description = "Parameter Store stringlist parameter names"
  value       = { for k, v in aws_ssm_parameter.stringlist : k => v.name }
}

output "ssm_parameter_securestring_parameter_names" {
  description = "Parameter Store securestring parameter names"
  value       = { for k, v in aws_ssm_parameter.securestring : k => v.name }
}
