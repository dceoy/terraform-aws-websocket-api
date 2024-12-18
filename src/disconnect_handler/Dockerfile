# syntax=docker/dockerfile:1
ARG NODE_VERSION=22
FROM public.ecr.aws/lambda/nodejs:${NODE_VERSION} AS app

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN \
      --mount=type=bind,source=.,target=/mnt/host \
      cp /mnt/host/index.js .

HEALTHCHECK NONE

CMD ["index.handler"]
