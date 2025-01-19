#!/usr/bin/env python

import json
import os
from functools import cache
from typing import Any

import boto3
from aws_lambda_powertools import Logger, Tracer
from aws_lambda_powertools.utilities.typing import LambdaContext
from botocore.exceptions import ClientError

logger = Logger()
tracer = Tracer()


@cache
def _instantiate_dynamodb_table() -> Any:
    """Instantiate a DynamoDB table resource.

    Returns:
        Any: DynamoDB Table resource.

    """
    return boto3.resource("dynamodb").Table(os.environ["DYNAMODB_TABLE_NAME"])


@logger.inject_lambda_context(log_event=True)
@tracer.capture_lambda_handler
def lambda_handler(event: dict[str, Any], context: LambdaContext) -> dict[str, Any]:  # noqa: ARG001
    """AWS Lambda function handler.

    This function is called when an API Gateway WebSocket connection is closed,
    and removes the connection ID from the DynamoDB table.

    Args:
        event (dict[str, Any]): The event data passed by AWS Lambda.
        context (LambdaContext): The runtime information provided by AWS Lambda.

    Returns:
        dict[str, Any]: A dictionary representing the API Gateway response.

    """
    table = _instantiate_dynamodb_table()
    try:
        table.delete_item(Key={"connectionId": event["requestContext"]["connectionId"]})
    except ClientError:
        logger.exception("Failed to remove the connection ID")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Failed to remove the connection ID"}),
        }
    else:
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Disconnected"}),
        }
