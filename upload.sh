#!/bin/bash
CONTAINER_ENGINE="${VARIABLE:-podman}"
IMAGE_REPO="${VARIABLE:-quay.io/redhat-ai-dev/ollama-ubi}"
OLLAMA_VERSION=$(cat VERSION)

$CONTAINER_ENGINE push $IMAGE_REPO:latest
$CONTAINER_ENGINE push $IMAGE_REPO:${OLLAMA_VERSION}
