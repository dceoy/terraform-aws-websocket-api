#!/usr/bin/env bash
#
# Usage:
#   ./build_docker_image.sh

set -euox pipefail

SRC_DIR="$(realpath "${0}" | xargs dirname)/src"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
AWS_REGION="$(aws configure get region)"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
TAG_NAME="sha-$(git rev-parse --short HEAD)"
BUILD_TARGET='app'
PLATFORMS='linux/arm64'

find "${SRC_DIR}" -type f -name Dockerfile -print0 | while IFS= read -r -d '' f; do
  context_dir="$(dirname "${f}")"
  image_name="$(basename "${context_dir}" | sed 's/_/-/g; s/^/ws-/')"
  docker buildx build \
    --tag "${ECR_REGISTRY}/${image_name}:${TAG_NAME}" \
    --target "${BUILD_TARGET}" \
    --platform "${PLATFORMS}" \
    --provenance false \
    "${context_dir}"
done
