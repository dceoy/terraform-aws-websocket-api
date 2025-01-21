resource "aws_lambda_function" "functions" {
  for_each                       = aws_iam_role.functions
  function_name                  = local.lambda_function_names[each.key]
  description                    = "Lambda function for ${each.key}"
  role                           = each.value.arn
  package_type                   = "Image"
  image_uri                      = local.lambda_image_uris[each.key]
  architectures                  = var.lambda_architectures
  memory_size                    = var.lambda_memory_sizes[each.key]
  timeout                        = var.lambda_timeout
  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
  logging_config {
    log_group             = aws_cloudwatch_log_group.functions[each.key].name
    log_format            = var.lambda_logging_config_log_format
    application_log_level = var.lambda_logging_config_log_format == "Text" ? null : var.lambda_logging_config_application_log_level
    system_log_level      = var.lambda_logging_config_log_format == "Text" ? null : var.lambda_logging_config_system_log_level
  }
  tracing_config {
    mode = var.lambda_tracing_config_mode
  }
  dynamic "environment" {
    for_each = lookup(var.lambda_environment_variables, each.key, null) != null ? [true] : []
    content {
      variables = lookup(var.lambda_environment_variables, each.key, null)
    }
  }
  dynamic "ephemeral_storage" {
    for_each = lookup(var.lambda_ephemeral_storage_sizes, each.key, null) != null ? [true] : []
    content {
      size = lookup(var.lambda_ephemeral_storage_sizes, each.key, null)
    }
  }
  dynamic "image_config" {
    for_each = lookup(var.lambda_image_config_entry_points, each.key, null) != null || lookup(var.lambda_image_config_commands, each.key, null) != null || lookup(var.lambda_image_config_working_directories, each.key, null) != null ? [true] : []
    content {
      entry_point       = lookup(var.lambda_image_config_entry_points, each.key, null)
      command           = lookup(var.lambda_image_config_commands, each.key, null)
      working_directory = lookup(var.lambda_image_config_working_directories, each.key, null)
    }
  }
  tags = {
    Name       = local.lambda_function_names[each.key]
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

# trivy:ignore:avd-aws-0017
resource "aws_cloudwatch_log_group" "functions" {
  for_each          = local.lambda_function_names
  name              = "/${var.system_name}/${var.env_type}/lambda/${each.value}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.kms_key_arn
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/lambda/${each.value}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_lambda_provisioned_concurrency_config" "functions" {
  for_each                          = var.lambda_provisioned_concurrent_executions > -1 && length(aws_lambda_function.functions) > 0 ? aws_lambda_function.functions : {}
  function_name                     = each.value.function_name
  qualifier                         = each.value.version == "$LATEST" ? null : each.value.version
  provisioned_concurrent_executions = var.lambda_provisioned_concurrent_executions
}

resource "aws_lambda_function_url" "api" {
  function_name      = aws_lambda_function.functions["webhook-handler"].function_name
  qualifier          = aws_lambda_function.functions["webhook-handler"].version == "$LATEST" ? null : aws_lambda_function.functions["webhook-handler"].version
  authorization_type = var.lambda_function_url_authorization_type
  invoke_mode        = var.lambda_function_url_invoke_mode
  dynamic "cors" {
    for_each = length(var.lambda_function_url_cors) > 0 ? [true] : []
    content {
      allow_credentials = lookup(var.lambda_function_url_cors, "allow_credentials", null)
      allow_headers     = lookup(var.lambda_function_url_cors, "allow_headers", null)
      allow_methods     = lookup(var.lambda_function_url_cors, "allow_methods", null)
      allow_origins     = lookup(var.lambda_function_url_cors, "allow_origins", null)
      expose_headers    = lookup(var.lambda_function_url_cors, "expose_headers", null)
      max_age           = lookup(var.lambda_function_url_cors, "max_age", null)
    }
  }
}

resource "aws_iam_role" "functions" {
  for_each              = local.lambda_function_names
  name                  = "${var.system_name}-${var.env_type}-lambda-${each.key}-iam-role"
  description           = "Lambda execution IAM role for ${each.key}"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLambdaServiceToAssumeRole"
        Effect = "Allow"
        Action = ["sts:AssumeRole"]
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-lambda-${each.key}-iam-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role_policy_attachments_exclusive" "functions" {
  for_each  = aws_iam_role.functions
  role_name = each.value.id
  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  ]
}

resource "aws_iam_role_policy" "parameters" {
  for_each = aws_iam_role.functions
  name     = "${var.system_name}-${var.env_type}-lambda-${each.key}-parameters-iam-policy"
  role     = each.value.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Sid    = "AllowParameterStoreAccess"
          Effect = "Allow"
          Action = [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath"
          ]
          Resource = ["*"]
          Condition = {
            StringEquals = {
              "ssm:resourceTag/SystemName" = var.system_name
              "ssm:resourceTag/EnvType"    = var.env_type
            }
          }
        }
      ],
      (
        var.kms_key_arn != null ? [
          {
            Sid      = "AllowKMSDecrypt"
            Effect   = "Allow"
            Action   = ["kms:Decrypt"]
            Resource = [var.kms_key_arn]
          }
        ] : []
      )
    )
  })
}

resource "aws_iam_role_policy" "logs" {
  for_each = aws_iam_role.functions
  name     = "${var.system_name}-${var.env_type}-lambda-${each.key}-logs-iam-policy"
  role     = each.value.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Sid      = "AllowDescribeLogGroups"
          Effect   = "Allow"
          Action   = ["logs:DescribeLogGroups"]
          Resource = ["arn:aws:logs:${local.region}:${local.account_id}:log-group:*"]
        },
        {
          Sid    = "AllowLogStreamAccess"
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
          ]
          Resource = ["${aws_cloudwatch_log_group.functions[each.key].arn}:*"]
        }
      ],
      (
        var.kms_key_arn != null ? [
          {
            Sid      = "AllowKMSGenerateDataKey"
            Effect   = "Allow"
            Action   = ["kms:GenerateDataKey"]
            Resource = [var.kms_key_arn]
          }
        ] : []
      )
    )
  })
}

resource "aws_iam_role_policy" "connections" {
  for_each = toset(["connect-handler", "disconnect-handler"])
  name     = "${var.system_name}-${var.env_type}-lambda-${each.key}-connections-iam-policy"
  role     = aws_iam_role.functions[each.key].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowDynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = ["arn:aws:dynamodb:${local.region}:${local.account_id}:table/*"]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/SystemName" = var.system_name
            "aws:ResourceTag/EnvType"    = var.env_type
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "media" {
  for_each = toset(["media-handler"])
  name     = "${var.system_name}-${var.env_type}-lambda-${each.key}-media-iam-policy"
  role     = aws_iam_role.functions[each.key].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Sid    = "AllowDynamoDBAccess"
          Effect = "Allow"
          Action = [
            "dynamodb:BatchGetItem",
            "dynamodb:GetRecords",
            "dynamodb:GetShardIterator",
            "dynamodb:Query",
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:ConditionCheckItem",
            "dynamodb:DescribeTable"
          ]
          Resource = ["arn:aws:dynamodb:${local.region}:${local.account_id}:table/*"]
          Condition = {
            StringEquals = {
              "aws:ResourceTag/SystemName" = var.system_name
              "aws:ResourceTag/EnvType"    = var.env_type
            }
          }
        },
        {
          Sid      = "AllowAPIAccess"
          Effect   = "Allow"
          Action   = ["execute-api:ManageConnections"]
          Resource = ["arn:aws:execute-api:${local.region}:${local.account_id}:*/*/POST/@connections/*"]
          Condition = {
            StringEquals = {
              "aws:ResourceTag/SystemName" = var.system_name
              "aws:ResourceTag/EnvType"    = var.env_type
            }
          }
        }
      ],
      (
        var.kms_key_arn != null ? [
          {
            Sid    = "AllowKMSAccess"
            Effect = "Allow"
            Action = [
              "kms:Decrypt",
              "kms:Encrypt",
              "kms:GenerateDataKey"
            ]
            Resource = [var.kms_key_arn]
          }
        ] : []
      )
    )
  })
}
