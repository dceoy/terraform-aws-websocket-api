#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-lambda-hello-world}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
AWS_REGION="$(aws configure get region)"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "IMAGE_NAME:       ${IMAGE_NAME}"
echo "IMAGE_TAG:        ${IMAGE_TAG}"
echo "AWS_ACCOUNT_ID:   ${AWS_ACCOUNT_ID}"
echo "AWS_REGION:       ${AWS_REGION}"
echo "ECR_REGISTRY:     ${ECR_REGISTRY}"

set -x

docker image rm -f "${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}" || :
aws ecr delete-repository --repository-name "${IMAGE_NAME}" --force || :
