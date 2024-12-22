resource "aws_apigatewayv2_api" "websocket" {
  name                       = "${var.system_name}-${var.env_type}-websocket-api-gateway"
  description                = "${var.system_name}-${var.env_type}-websocket-api-gateway"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-websocket-api-gateway"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_lambda_permission" "connect" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function_names["connect-handler"]
  qualifier     = local.lambda_function_versions["connect-handler"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_apigatewayv2_api.websocket.id}/*$connect"
}

resource "aws_apigatewayv2_integration" "connect" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.connect_handler_lambda_function_invoke_arn
}

resource "aws_apigatewayv2_route" "connect" {
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "$connect"
  target             = "integrations/${aws_apigatewayv2_integration.connect.id}"
}

resource "aws_lambda_permission" "disconnect" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function_names["disconnect-handler"]
  qualifier     = local.lambda_function_versions["disconnect-handler"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_apigatewayv2_api.websocket.id}/*$disconnect"
}

resource "aws_apigatewayv2_integration" "disconnect" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.disconnect_handler_lambda_function_invoke_arn
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "$disconnect"
  target             = "integrations/${aws_apigatewayv2_integration.disconnect.id}"
}

resource "aws_lambda_permission" "sendmessage" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function_names["sendmessage-handler"]
  qualifier     = local.lambda_function_versions["sendmessage-handler"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_apigatewayv2_api.websocket.id}/*sendmessage"
}

resource "aws_apigatewayv2_integration" "sendmessage" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.sendmessage_handler_lambda_function_invoke_arn
}

resource "aws_apigatewayv2_route" "sendmessage" {
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "sendmessage"
  target             = "integrations/${aws_apigatewayv2_integration.sendmessage.id}"
}

resource "aws_lambda_permission" "default" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function_names["default-handler"]
  qualifier     = local.lambda_function_versions["default-handler"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_apigatewayv2_api.websocket.id}/*$default"
}

resource "aws_apigatewayv2_integration" "default" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.default_handler_lambda_function_invoke_arn
}

resource "aws_apigatewayv2_route" "default" {
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "$default"
  target             = "integrations/${aws_apigatewayv2_integration.default.id}"
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
