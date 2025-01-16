output "connect_handler_lambda_function_name" {
  description = "Lambda function name of the connect handler"
  value       = aws_lambda_function.functions["connect-handler"].function_name
}

output "connect_handler_lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN of the connect handler"
  value       = aws_lambda_function.functions["connect-handler"].qualified_arn
}

output "connect_handler_lambda_function_version" {
  description = "Lambda function version of the connect handler"
  value       = aws_lambda_function.functions["connect-handler"].version
}

output "connect_handler_lambda_function_invoke_arn" {
  description = "Lambda function invoke ARN of the connect handler"
  value       = aws_lambda_function.functions["connect-handler"].invoke_arn
}

output "disconnect_handler_lambda_function_name" {
  description = "Lambda function name of the disconnect handler"
  value       = aws_lambda_function.functions["disconnect-handler"].function_name
}

output "disconnect_handler_lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN of the disconnect handler"
  value       = aws_lambda_function.functions["disconnect-handler"].qualified_arn
}

output "disconnect_handler_lambda_function_version" {
  description = "Lambda function version of the disconnect handler"
  value       = aws_lambda_function.functions["disconnect-handler"].version
}

output "disconnect_handler_lambda_function_invoke_arn" {
  description = "Lambda function invoke ARN of the disconnect handler"
  value       = aws_lambda_function.functions["disconnect-handler"].invoke_arn
}

output "sendmessage_handler_lambda_function_name" {
  description = "Lambda function name of the sendmessage handler"
  value       = aws_lambda_function.functions["sendmessage-handler"].function_name
}

output "sendmessage_handler_lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN of the sendmessage handler"
  value       = aws_lambda_function.functions["sendmessage-handler"].qualified_arn
}

output "sendmessage_handler_lambda_function_version" {
  description = "Lambda function version of the sendmessage handler"
  value       = aws_lambda_function.functions["sendmessage-handler"].version
}

output "sendmessage_handler_lambda_function_invoke_arn" {
  description = "Lambda function invoke ARN of the sendmessage handler"
  value       = aws_lambda_function.functions["sendmessage-handler"].invoke_arn
}

output "webhook_handler_lambda_function_name" {
  description = "Lambda function name of the webhook handler"
  value       = aws_lambda_function.functions["webhook-handler"].function_name
}

output "webhook_handler_lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN of the webhook handler"
  value       = aws_lambda_function.functions["webhook-handler"].qualified_arn
}

output "webhook_handler_lambda_function_version" {
  description = "Lambda function version of the webhook handler"
  value       = aws_lambda_function.functions["webhook-handler"].version
}

output "webhook_handler_lambda_function_invoke_arn" {
  description = "Lambda function invoke ARN of the webhook handler"
  value       = aws_lambda_function.functions["webhook-handler"].invoke_arn
}

output "default_handler_lambda_function_name" {
  description = "Lambda function name of the default handler"
  value       = aws_lambda_function.functions["default-handler"].function_name
}

output "default_handler_lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN of the default handler"
  value       = aws_lambda_function.functions["default-handler"].qualified_arn
}

output "default_handler_lambda_function_version" {
  description = "Lambda function version of the default handler"
  value       = aws_lambda_function.functions["default-handler"].version
}

output "default_handler_lambda_function_invoke_arn" {
  description = "Lambda function invoke ARN of the default handler"
  value       = aws_lambda_function.functions["default-handler"].invoke_arn
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

output "webhook_handler_lambda_iam_role_arn" {
  description = "Lambda IAM role ARN of the webhook handler"
  value       = aws_iam_role.functions["webhook-handler"].arn
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

output "webhook_handler_lambda_cloudwatch_logs_log_group_name" {
  description = "Lambda CloudWatch Logs log group name of the webhook handler"
  value       = aws_cloudwatch_log_group.functions["webhook-handler"].name
}

output "webhook_handler_lambda_function_url" {
  description = "Lambda Function URL of the webhook handler"
  value       = aws_lambda_function_url.api.function_url
}

output "webhook_handler_lambda_function_url_id" {
  description = "Lambda Function URL ID of the webhook handler"
  value       = aws_lambda_function_url.api.url_id
}
