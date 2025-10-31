ARG IMAGE=docker.io/nvidia/cuda:12.6.3-devel-ubi9
FROM ${IMAGE}

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN dnf install -y --nodocs pciutils \
    && dnf clean all && rm -rf /var/cache/*

USER root

WORKDIR /ollama

ENV OLLAMA_VERSION=0.12.8

RUN chmod 770 /ollama && \
    chgrp root /ollama && \
    curl -s https://ollama.ai/install.sh | sh

EXPOSE 8080
USER 1001

ENV HOME=/ollama \
    OLLAMA_HOST=0.0.0.0:11434 \
    OLLAMA_MODELS=/ollama/models

ENTRYPOINT ["/usr/local/bin/ollama"]
CMD ["serve"]

LABEL \
      org.opencontainers.image.description.vendor="ollama" \
      org.opencontainers.image.description="A UBI container used to run ollama" \
      org.opencontainers.image.source="https://github.com/redhat-na-ssa/demo-ollama"
