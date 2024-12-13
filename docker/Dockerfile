# syntax=docker/dockerfile:1
ARG NODE_VERSION=22
FROM public.ecr.aws/lambda/nodejs:${NODE_VERSION}-slim AS base

ARG USER_UID=1001
ARG USER_GID=1001
ARG USER_NAME=websocket

ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN \
      groupadd --gid "${USER_GID}" "${USER_NAME}" \
      && useradd --uid "${USER_UID}" --gid "${USER_GID}" --shell /bin/bash --no-create-home "${USER_NAME}"

RUN \
      rm -f /etc/apt/apt.conf.d/docker-clean \
      && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
        > /etc/apt/apt.conf.d/keep-cache

RUN \
      --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
      apt-get -y update \
      && apt-get -y upgrade

HEALTHCHECK NONE

RUN \
      chown -R "${USER_NAME}:${USER_NAME}" .

USER "${USER_NAME}"


FROM base AS connect-hanlder

RUN \
      --mount=type=bind,source=.,target=/mnt/host \
      cp /mnt/host/connect_handler.js .

CMD ["connect_handler.handler"]


FROM base AS disconnect-handler

RUN \
      --mount=type=bind,source=.,target=/mnt/host \
      cp /mnt/host/disconnect_handler.js .

CMD ["disconnect_handler.handler"]


FROM base AS sendmessage-handler

RUN \
      --mount=type=bind,source=.,target=/mnt/host \
      cp /mnt/host/sendmessage_handler.js .

CMD ["sendmessage_handler.handler"]


FROM base AS default-handler

RUN \
      --mount=type=bind,source=.,target=/mnt/host \
      cp /mnt/host/default_handler.js .

CMD ["default_handler.handler"]
