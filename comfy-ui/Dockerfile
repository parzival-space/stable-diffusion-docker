FROM docker.io/nvidia/cuda:13.3.1-devel-ubuntu26.04

LABEL org.opencontainers.image.source=https://github.com/parzival-space/stable-diffusion-docker
LABEL org.opencontainers.image.description="Simple Click-and-Run Docker Image for Stable Diffusion WebUI"
LABEL org.opencontainers.image.licenses=AGPL-3.0-only

# install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends --no-install-suggests -y curl git && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8188/tcp

VOLUME /comfy-ui

WORKDIR /comfy-ui
USER ubuntu
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]