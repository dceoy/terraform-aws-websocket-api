#!/usr/bin/env bash
#
# Usage:
#   ./build_docker_image.sh

set -euox pipefail

cd "$(dirname "${0}")"

AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
AWS_REGION="$(aws configure get region)"
TAG="sha-$(git rev-parse --short HEAD)"
export AWS_ACCOUNT_ID AWS_REGION TAG

docker buildx bake
