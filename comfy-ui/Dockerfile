FROM nvidia/cuda:12.2.0-devel-ubuntu20.04

LABEL org.opencontainers.image.source=https://github.com/parzival-space/stable-diffusion-docker
LABEL org.opencontainers.image.description="Simple Click-and-Run Docker Image for Stable Diffusion WebUI"
LABEL org.opencontainers.image.licenses=AGPL-3.0-only

# install dependencies
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends --no-install-suggests -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa
RUN apt update && \
    apt install --no-install-recommends --no-install-suggests -y \
        git \
        g++ \
        google-perftools \
        ffmpeg \
        libsm6 \
        libxext6 \
        sudo \
        curl \
        python3.10 \
        python3.10-distutils \
        python3.10-venv \
        python3.10-dev

# setup python
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    update-alternatives --set python3 /usr/bin/python3.10 && \
    python3.10 -m ensurepip && \
    python3.10 -m pip install --upgrade pip
ENV PYTHONUNBUFFERED=1 \
    PATH="$PATH:/home/stable_diffusion/.local/bin" \
    TORCH_CUDA_ARCH_LIST=All \
    FORCE_CUDA=1 \
    PYTHON_CMD=/usr/bin/python3

# create stable diffusion user
RUN useradd -mp $(openssl passwd -1 SuperSecurePassword) -G sudo stable_diffusion && \
    echo "stable_diffusion ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/stable_diffusion

# prepare entrypoint script
COPY entrypoint.sh /home/stable_diffusion/entrypoint.sh
RUN mkdir -p /data && \
    chown stable_diffusion:stable_diffusion -R /data && \
    chown stable_diffusion:stable_diffusion -R /home/stable_diffusion

# setup stable diffusion user
WORKDIR /home/stable_diffusion
USER stable_diffusion

EXPOSE 7680/tcp
CMD ["/bin/bash", "/home/stable_diffusion/entrypoint.sh"]