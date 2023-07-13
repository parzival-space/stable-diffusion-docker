# Stable Diffusion Docker
A simple read-to-run docker container for Stable Diffusion Web Ui.

![preview](./.github/readme/preview.png)

## Getting Started
To use this container, follow these simple steps:

### Prerequisites
Make sure you have Docker installed and configured on your system.
Also you need a Nvidia graphics card. This container only works with an Nvidia Card.

### Starting the Container
To start the container, execute the following command:
```bash
docker run \
  -v ./data:/data:rw \
  -p 7680:7680/tcp \
  --gpu all \
  ghcr.io/parzival-space/stable-diffusion:latest
```
Alternatively, you can use the provided ``docker-compose.yml`` file if you prefer.

## License
Because of the licensing of [stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui), this project is also licensed under the GNU Affero General Public License v3.0.
For more information, please refer to the ``LICENSE`` file.