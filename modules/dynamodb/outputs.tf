output "connection_dynamodb_table_id" {
  description = "Connection DynamoDB table ID"
  value       = aws_dynamodb_table.connection.id
}

output "connection_dynamodb_table_arn" {
  description = "Connection DynamoDB table ARN"
  value       = aws_dynamodb_table.connection.arn
}
