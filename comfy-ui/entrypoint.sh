#!/bin/bash
set -e

COMFY_INSTALL_DIR="/comfy-ui"
COMFY_VENV_DIR="${COMFY_INSTALL_DIR}/.venv/comfy"
COMFY_PYTHON_VERSION="3.13"
COMFY_REPOSITORY="https://github.com/Comfy-Org/ComfyUI.git"
COMFY_TAG=${COMFY_TAG:="v0.31.1"}

MINICONDA_INSTALL_DIR="${COMFY_INSTALL_DIR}/.venv/miniconda"
MINICONDA_INSTALL_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
MINICONDA_ACTIVATE="${MINICONDA_INSTALL_DIR}/bin/activate"

UPDATE_DEPENDENCIES=${UPDATE_DEPENDENCIES:=false}

# Install ComfyUI
if [ ! -e "${COMFY_INSTALL_DIR}/.git" ]; then
  echo "Downloading ComfyUI"
  set -x
  # shellcheck disable=SC2115
  rm -rf "${COMFY_INSTALL_DIR}"/* "${COMFY_INSTALL_DIR}"/.[!.]* "${COMFY_INSTALL_DIR}"/..?* 2>/dev/null || true
  git clone --depth 1 --branch "${COMFY_TAG}" "${COMFY_REPOSITORY}" "${COMFY_INSTALL_DIR}"
  set +x
fi

# install and activate miniconda
if [ ! -e "${MINICONDA_ACTIVATE}" ]; then
  echo "Installing Miniconda"
  set -x

  MINICONDA_INSTALLER="/tmp/Miniconda3-latest-Linux-x86_64.sh"
  curl -o "${MINICONDA_INSTALLER}" "${MINICONDA_INSTALL_URL}"
  bash "${MINICONDA_INSTALLER}" -b -u -p "${MINICONDA_INSTALL_DIR}"

  set +x
fi

echo "Activating Miniconda"
set -x
export CONDA_PLUGINS_AUTO_ACCEPT_TOS=${CONDA_PLUGINS_AUTO_ACCEPT_TOS:=true}
# shellcheck disable=SC1090
source "${MINICONDA_ACTIVATE}"
conda init --user -q
# shellcheck disable=SC1090
source ~/.bashrc
set +x

# create ComfyUI virtual environment
if [ ! -e "${COMFY_VENV_DIR}/bin/python" ]; then
  echo "Creating ComfyUI environment"
  set -x
  conda create -p "${COMFY_VENV_DIR}" -y -q python=${COMFY_PYTHON_VERSION}
  UPDATE_DEPENDENCIES=true
  set +x
fi

echo "Activating ConfyUI environment"
set -x
conda activate /comfy-ui/.venv/comfy
set +x

# Installing dependencies
if [ "$UPDATE_DEPENDENCIES" == "true" ]; then
  echo "Installing dependencies"
  set -x
  # install cuda dependencies
  pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu130

  # install comfyui dependencies
  pip install -r requirements.txt
  set +x
fi

# Launch ComfyUI
set -x
# shellcheck disable=SC2086
python main.py --listen 0.0.0.0 --port 8188 ${ARGS:=""}
set +x