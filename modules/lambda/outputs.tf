output "connect_handler_lambda_function_arn" {
  description = "Lambda function ARN of the connect handler"
  value       = aws_lambda_function.functions["connect-handler"].arn
}

output "connect_handler_lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN of the connect handler"
  value       = aws_lambda_function.functions["connect-handler"].qualified_arn
}

output "connect_handler_lambda_function_version" {
  description = "Lambda function version of the connect handler"
  value       = aws_lambda_function.functions["connect-handler"].version
}

output "disconnect_handler_lambda_function_arn" {
  description = "Lambda function ARN of the disconnect handler"
  value       = aws_lambda_function.functions["disconnect-handler"].arn
}

output "disconnect_handler_lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN of the disconnect handler"
  value       = aws_lambda_function.functions["disconnect-handler"].qualified_arn
}

output "disconnect_handler_lambda_function_version" {
  description = "Lambda function version of the disconnect handler"
  value       = aws_lambda_function.functions["disconnect-handler"].version
}

output "sendmessage_handler_lambda_function_arn" {
  description = "Lambda function ARN of the sendmessage handler"
  value       = aws_lambda_function.functions["sendmessage-handler"].arn
}

output "sendmessage_handler_lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN of the sendmessage handler"
  value       = aws_lambda_function.functions["sendmessage-handler"].qualified_arn
}

output "sendmessage_handler_lambda_function_version" {
  description = "Lambda function version of the sendmessage handler"
  value       = aws_lambda_function.functions["sendmessage-handler"].version
}

output "default_handler_lambda_function_arn" {
  description = "Lambda function ARN of the default handler"
  value       = aws_lambda_function.functions["default-handler"].arn
}

output "default_handler_lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN of the default handler"
  value       = aws_lambda_function.functions["default-handler"].qualified_arn
}

output "default_handler_lambda_function_version" {
  description = "Lambda function version of the default handler"
  value       = aws_lambda_function.functions["default-handler"].version
}

output "connect_handler_lambda_iam_role_arn" {
  description = "Lambda IAM role ARN of the connect handler"
  value       = aws_iam_role.functions["connect-handler"].arn
}

output "disconnect_handler_lambda_iam_role_arn" {
  description = "Lambda IAM role ARN of the disconnect handler"
  value       = aws_iam_role.functions["disconnect-handler"].arn
}

output "sendmessage_handler_lambda_iam_role_arn" {
  description = "Lambda IAM role ARN of the sendmessage handler"
  value       = aws_iam_role.functions["sendmessage-handler"].arn
}

output "default_handler_lambda_iam_role_arn" {
  description = "Lambda IAM role ARN of the default handler"
  value       = aws_iam_role.functions["default-handler"].arn
}

output "connect_handler_lambda_cloudwatch_logs_log_group_name" {
  description = "Lambda CloudWatch Logs log group name of the connect handler"
  value       = aws_cloudwatch_log_group.functions["connect-handler"].name
}

output "disconnect_handler_lambda_cloudwatch_logs_log_group_name" {
  description = "Lambda CloudWatch Logs log group name of the disconnect handler"
  value       = aws_cloudwatch_log_group.functions["disconnect-handler"].name
}

output "sendmessage_handler_lambda_cloudwatch_logs_log_group_name" {
  description = "Lambda CloudWatch Logs log group name of the sendmessage handler"
  value       = aws_cloudwatch_log_group.functions["sendmessage-handler"].name
}

output "default_handler_lambda_cloudwatch_logs_log_group_name" {
  description = "Lambda CloudWatch Logs log group name of the default handler"
  value       = aws_cloudwatch_log_group.functions["default-handler"].name
}
