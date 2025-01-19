resource "aws_apigatewayv2_api" "websocket" {
  name                         = "${var.system_name}-${var.env_type}-websocket-api-gateway"
  description                  = "WebSocket API Gateway for ${var.system_name}-${var.env_type}"
  protocol_type                = "WEBSOCKET"
  route_selection_expression   = "$request.body.action"
  version                      = var.apigateway_api_version
  api_key_selection_expression = var.apigateway_api_key_selection_expression
  tags = {
    Name       = "${var.system_name}-${var.env_type}-websocket-api-gateway"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_apigatewayv2_route" "connect" {
  operation_name     = "${aws_apigatewayv2_api.websocket.name}-connect-route"
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "$connect"
  target             = "integrations/${aws_apigatewayv2_integration.connect.id}"
}

resource "aws_apigatewayv2_integration" "connect" {
  api_id           = aws_apigatewayv2_api.websocket.id
  description      = "${aws_apigatewayv2_api.websocket.name}-connect-integration"
  integration_type = "AWS_PROXY"
  integration_uri  = var.connect_handler_lambda_function_invoke_arn
}

resource "aws_apigatewayv2_route_response" "connect_route_response" {
  api_id             = aws_apigatewayv2_api.websocket.id
  route_id           = aws_apigatewayv2_route.connect.id
  route_response_key = "$default"
}

resource "aws_lambda_permission" "connect" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function_names["connect-handler"]
  qualifier     = local.lambda_function_versions["connect-handler"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_apigatewayv2_api.websocket.id}/*$connect"
}

resource "aws_apigatewayv2_route" "disconnect" {
  operation_name     = "${aws_apigatewayv2_api.websocket.name}-disconnect-route"
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "$disconnect"
  target             = "integrations/${aws_apigatewayv2_integration.disconnect.id}"
}

resource "aws_apigatewayv2_integration" "disconnect" {
  api_id           = aws_apigatewayv2_api.websocket.id
  description      = "${aws_apigatewayv2_api.websocket.name}-disconnect-integration"
  integration_type = "AWS_PROXY"
  integration_uri  = var.disconnect_handler_lambda_function_invoke_arn
}

resource "aws_lambda_permission" "disconnect" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function_names["disconnect-handler"]
  qualifier     = local.lambda_function_versions["disconnect-handler"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_apigatewayv2_api.websocket.id}/*$disconnect"
}

resource "aws_apigatewayv2_route" "default" {
  operation_name     = "${aws_apigatewayv2_api.websocket.name}-default-route"
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "$default"
  target             = "integrations/${aws_apigatewayv2_integration.default.id}"
}

resource "aws_apigatewayv2_integration" "default" {
  api_id           = aws_apigatewayv2_api.websocket.id
  description      = "${aws_apigatewayv2_api.websocket.name}-default-integration"
  integration_type = "MOCK"
  request_templates = {
    "200" = jsonencode({
      statusCode = 200
    })
  }
  template_selection_expression = "200"
  passthrough_behavior          = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_integration_response" "default" {
  api_id                   = aws_apigatewayv2_api.websocket.id
  integration_id           = aws_apigatewayv2_integration.default.id
  integration_response_key = "$default"
  response_templates = {
    "200" = "This is a mock response."
  }
  template_selection_expression = "200"
}

resource "aws_apigatewayv2_route_response" "default" {
  api_id             = aws_apigatewayv2_api.websocket.id
  route_id           = aws_apigatewayv2_route.default.id
  route_response_key = "$default"
}

resource "aws_apigatewayv2_route" "media" {
  operation_name     = "${aws_apigatewayv2_api.websocket.name}-media-route"
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "media"
  target             = "integrations/${aws_apigatewayv2_integration.media.id}"
}

resource "aws_apigatewayv2_integration" "media" {
  api_id           = aws_apigatewayv2_api.websocket.id
  description      = "${aws_apigatewayv2_api.websocket.name}-media-integration"
  integration_type = "AWS_PROXY"
  integration_uri  = var.media_handler_lambda_function_invoke_arn
}

resource "aws_lambda_permission" "media" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function_names["media-handler"]
  qualifier     = local.lambda_function_versions["media-handler"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_apigatewayv2_api.websocket.id}/*media"
}

# trivy:ignore:avd-aws-0017
resource "aws_cloudwatch_log_group" "websocket" {
  name              = "/${var.system_name}/${var.env_type}/apigateway/${aws_apigatewayv2_api.websocket.id}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.kms_key_arn
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/apigateway/${aws_apigatewayv2_api.websocket.id}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_apigatewayv2_stage" "websocket" {
  name        = "production"
  description = "Production stage for ${aws_apigatewayv2_api.websocket.name}"
  api_id      = aws_apigatewayv2_api.websocket.id
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.websocket.arn
    format = jsonencode({
      requestId         = "$context.requestId"
      extendedRequestId = "$context.extendedRequestId"
      ip                = "$context.identity.sourceIp"
      caller            = "$context.identity.caller"
      user              = "$context.identity.user"
      requestTime       = "$context.requestTime"
      httpMethod        = "$context.httpMethod"
      resourcePath      = "$context.resourcePath"
      status            = "$context.status"
      protocol          = "$context.protocol"
      responseLength    = "$context.responseLength"
    })
  }
  tags = {
    Name       = "${aws_apigatewayv2_api.websocket.name}-production"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
