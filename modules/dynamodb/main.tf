# trivy:ignore:avd-aws-0024
# trivy:ignore:avd-aws-0025
resource "aws_dynamodb_table" "connection" {
  name           = "${var.system_name}-${var.env_type}-connection-dynamodb-table"
  hash_key       = var.dynamodb_hash_key_for_connection_table
  table_class    = var.dynamodb_table_class
  billing_mode   = var.dynamodb_billing_mode
  read_capacity  = var.dynamodb_billing_mode == "PROVISIONED" ? var.dynamodb_read_capacity : null
  write_capacity = var.dynamodb_billing_mode == "PROVISIONED" ? var.dynamodb_write_capacity : null
  attribute {
    name = var.dynamodb_hash_key_for_connection_table
    type = "S"
  }
  point_in_time_recovery {
    enabled = var.dynamodb_point_in_time_recovery_enabled
  }
  dynamic "server_side_encryption" {
    for_each = var.kms_key_arn != null ? [true] : []
    content {
      enabled     = true
      kms_key_arn = var.kms_key_arn
    }
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-connection-dynamodb-table"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
