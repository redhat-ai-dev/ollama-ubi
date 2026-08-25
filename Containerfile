ARG IMAGE=docker.io/nvidia/cuda:12.6.3-devel-ubi9
FROM ${IMAGE}

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN dnf install -y --nodocs pciutils zstd \
    && dnf clean all && rm -rf /var/cache/*

USER root

WORKDIR /ollama

# build.sh may pass v0.32.15; GitHub release tags include the v prefix.
ARG OLLAMA_VERSION=0.32.15
ENV OLLAMA_VERSION=${OLLAMA_VERSION}

# 0.15+ Linux packages are .tar.zst only. The upstream install.sh needs zstd,
# tries to configure systemd/NVIDIA drivers, and `curl | sh` without pipefail
# can succeed without installing /usr/local/bin/ollama.
RUN chmod 770 /ollama && chgrp root /ollama && \
    set -euxo pipefail && \
    VERSION="${OLLAMA_VERSION#v}" && \
    ARCH="$(uname -m)" && \
    case "${ARCH}" in \
      x86_64) ARCH=amd64 ;; \
      aarch64|arm64) ARCH=arm64 ;; \
      *) echo "Unsupported architecture: ${ARCH}" >&2; exit 1 ;; \
    esac && \
    curl -fsSL "https://github.com/ollama/ollama/releases/download/v${VERSION}/ollama-linux-${ARCH}.tar.zst" \
      | zstd -d \
      | tar -xf - -C /usr/local && \
    test -x /usr/local/bin/ollama

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
