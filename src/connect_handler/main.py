#!/usr/bin/env python
"""AWS Lambda function handler for opening WebSocket connections."""

import json
import os
from typing import Any

import boto3
from aws_lambda_powertools import Logger, Tracer
from aws_lambda_powertools.utilities.typing import LambdaContext
from botocore.exceptions import ClientError

logger = Logger()
tracer = Tracer()
dynamodb = boto3.client("dynamodb")


@logger.inject_lambda_context(log_event=True)
@tracer.capture_lambda_handler
def lambda_handler(event: dict[str, Any], context: LambdaContext) -> dict[str, Any]:  # noqa: ARG001
    """AWS Lambda function handler.

    This function is called when an API Gateway WebSocket connection is made,
    and stores the connection ID in the DynamoDB table.

    Args:
        event (dict[str, Any]): The event data passed by AWS Lambda.
        context (LambdaContext): The runtime information provided by AWS Lambda.

    Returns:
        dict[str, Any]: A dictionary representing the API Gateway response.

    """
    try:
        dynamodb.put_item(
            TableName=os.environ["CONNECTION_DYNAMODB_TABLE_NAME"],
            Item={"connectionId": {"S": event["requestContext"]["connectionId"]}},
        )
    except ClientError:
        logger.exception("Failed to store the connection ID")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Failed to store the connection ID"}),
        }
    else:
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Connected"}),
        }
