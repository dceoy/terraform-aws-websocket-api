output "apigateway_api_id" {
  description = "API Gateway API ID"
  value       = aws_apigatewayv2_api.websocket.id
}

output "apigateway_api_endpoint" {
  description = "API Gateway API endpoint"
  value       = aws_apigatewayv2_api.websocket.api_endpoint
}

output "apigateway_connect_integration_id" {
  description = "API Gateway integration ID for $connect route"
  value       = aws_apigatewayv2_integration.connect.id
}

output "apigateway_connect_route_id" {
  description = "API Gateway route ID for $connect route"
  value       = aws_apigatewayv2_route.connect.id
}

output "apigateway_disconnect_integration_id" {
  description = "API Gateway integration ID for $disconnect route"
  value       = aws_apigatewayv2_integration.disconnect.id
}

output "apigateway_disconnect_route_id" {
  description = "API Gateway route ID for $disconnect route"
  value       = aws_apigatewayv2_route.disconnect.id
}

output "apigateway_sendmessage_integration_id" {
  description = "API Gateway integration ID for sendmessage route"
  value       = aws_apigatewayv2_integration.sendmessage.id
}

output "apigateway_sendmessage_route_id" {
  description = "API Gateway route ID for sendmessage route"
  value       = aws_apigatewayv2_route.sendmessage.id
}

output "apigateway_default_integration_id" {
  description = "API Gateway integration ID for $default route"
  value       = aws_apigatewayv2_integration.default.id
}

output "apigateway_default_route_id" {
  description = "API Gateway route ID for $default route"
  value       = aws_apigatewayv2_route.default.id
}

output "apigateway_api_stage_id" {
  description = "API Gateway API stage ID"
  value       = aws_apigatewayv2_stage.websocket.id
}

output "apigateway_api_stage_invoke_url" {
  description = "API Gateway API stage invoke URL"
  value       = aws_apigatewayv2_stage.websocket.invoke_url
}

output "apigateway_cloudwatch_log_group_name" {
  description = "API Gateway CloudWatch log group name"
  value       = aws_cloudwatch_log_group.websocket.name
}
