FROM nvidia/cuda:12.2.0-devel-ubuntu20.04

LABEL org.opencontainers.image.source=https://github.com/parzival-space/stable-diffusion-docker
LABEL org.opencontainers.image.description="Simple Click-and-Run Docker Image for Stable Diffusion WebUI"
LABEL org.opencontainers.image.licenses=AGPL-3.0-only

# install dependencies
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends --no-install-suggests -y \
        git \
        g++ \
        google-perftools \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        ffmpeg \
        libsm6 \
        libxext6 \
        sudo \
        curl

# setup python
RUN pip install --upgrade pip
ENV PYTHONUNBUFFERED=1 \
    PATH="$PATH:/home/stable_diffusion/.local/bin" \
    TORCH_CUDA_ARCH_LIST=All \
    FORCE_CUDA=1

# create stable diffusion user
RUN useradd -mp $(openssl passwd -1 SuperSecurePassword) -G sudo stable_diffusion && \
    echo "stable_diffusion ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/stable_diffusion

# prepare entrypoint script
COPY entrypoint.sh /home/stable_diffusion/entrypoint.sh
RUN mkdir -p /data && \
    chown stable_diffusion:stable_diffusion -R /data && \
    chown stable_diffusion:stable_diffusion -R /home/stable_diffusion

# setup stable diffusion web
WORKDIR /home/stable_diffusion
USER stable_diffusion
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git ./webui && \
    mv ./webui/models ./webui/models-default && \
    mv ./webui/configs ./webui/configs-default && \
    mv ./webui/embeddings ./webui/embeddings-default

WORKDIR /home/stable_diffusion/webui
EXPOSE 7680/tcp
CMD ["/bin/bash", "/home/stable_diffusion/entrypoint.sh"]