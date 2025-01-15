#!/bin/bash
CONTAINER_ENGINE="${VARIABLE:-podman}"
IMAGE_REPO="${VARIABLE:-quay.io/redhat-ai-dev/ollama-ubi}"

#OLLAMA_VERSION=$(curl -s "https://api.github.com/repos/ollama/ollama/releases/latest" | jq -r .name)
OLLAMA_VERSION="v0.5.5"

echo ${OLLAMA_VERSION} > VERSION

$CONTAINER_ENGINE build --no-cache --build-arg=VERSION=${OLLAMA_VERSION} -t $IMAGE_REPO:latest -f Containerfile.build
$CONTAINER_ENGINE tag $IMAGE_REPO:latest $IMAGE_REPO:${OLLAMA_VERSION}
