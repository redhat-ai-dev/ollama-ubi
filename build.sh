#!/bin/bash
CONTAINER_ENGINE="${VARIABLE:-podman}"
IMAGE_REPO="${VARIABLE:-quay.io/redhat-ai-dev/ollama-ubi}"

OLLAMA_VERSION="v0.12.8"

echo ${OLLAMA_VERSION} > VERSION

$CONTAINER_ENGINE build --no-cache --build-arg=OLLAMA_VERSION=${OLLAMA_VERSION} -t $IMAGE_REPO:latest -f Containerfile
$CONTAINER_ENGINE tag $IMAGE_REPO:latest $IMAGE_REPO:${OLLAMA_VERSION}
