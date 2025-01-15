#!/usr/bin/env python

import os
from typing import Any

from aws_lambda_powertools import Logger, Tracer
from aws_lambda_powertools.event_handler import LambdaFunctionUrlResolver
from aws_lambda_powertools.event_handler.exceptions import BadRequestError
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext
from twilio.request_validator import RequestValidator
from twilio.twiml.voice_response import Connect, VoiceResponse

logger = Logger()
tracer = Tracer()
app = LambdaFunctionUrlResolver()


@app.get("/")
@tracer.capture_method
def index_page():
    return {"message": "Lambda function is running!"}


@app.post("/incoming-call")
@tracer.capture_method
def handle_incoming_call() -> dict[str, Any]:
    """Handle incoming call and return TwiML response to connect to Media Stream.

    Args:
        request (Request): Incoming HTTP request.

    Returns:
        HTMLResponse: TwiML response to connect to Media Stream.

    """
    _validate_twilio_signature()
    response = VoiceResponse()
    # <Say> punctuation to improve text-to-speech flow
    response.say(
        "Please wait while we connect your call to the AI voice assistant,"
        " powered by Twilio and the Open-AI Realtime API"
    )
    response.pause(length=1)
    response.say("O.K. you can start talking!")
    connect = Connect()
    connect.stream(url=os.environ.get("WEBSOCKET_MEDIA_STREAM_URL"))
    response.append(connect)
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/xml"},
        "body": str(response),
    }


def _validate_twilio_signature() -> None:
    """Validate incoming Twilio request signature.

    Args:
        current_event (dict[str, Any]): The current event data passed by AWS Lambda.

    Raises:
        BadRequestError: If the request signature is invalid.

    """
    uri = app.current_event.request_context.domain_name + app.current_event.path
    params = app.current_event.json_body
    signature = app.current_event.get_header_value(
        name="X-Twilio-Signature",
        case_sensitive=True,
    )
    validator = RequestValidator(os.environ.get("TWILIO_AUTH_TOKEN"))
    if not validator.validate(uri=uri, params=params, signature=signature):
        raise BadRequestError("Invalid Twilio request signature")


@logger.inject_lambda_context(
    correlation_id_path=correlation_paths.LAMBDA_FUNCTION_URL,
    log_event=True,
)
@tracer.capture_lambda_handler
def lambda_handler(event: dict[str, Any], context: LambdaContext) -> dict[str, Any]:
    """AWS Lambda function handler.

    This function uses LambdaFunctionUrlResolver to handle incoming HTTP events
    and route requests to the appropriate endpoints.

    Args:
        event (dict[str, Any]): The event data passed by AWS Lambda.
        context (LambdaContext): The runtime information provided by AWS Lambda.

    Returns:
        dict[str, Any]: A dictionary representing the HTTP response.

    """
    logger.info("Event received")
    return app.resolve(event, context)
