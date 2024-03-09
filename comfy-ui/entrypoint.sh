#!/bin/bash
set -e

dataDir=/data
comfyDir=$dataDir/comfy-ui
comfyRepo="https://github.com/comfyanonymous/ComfyUI"
subDirs=("custom_nodes" "models" "output" "venv")

# fix permissions (because docker mounts suck)
sudo chown "$(whoami):$(whoami)" -R $dataDir

# download comfyUI if required
if [ "$(ls -A $comfyDir)" = "" ]; then
  echo "Downloading comfyUI..."
  mkdir -p "$comfyDir"
  git clone --single-branch "$comfyRepo" "$comfyDir/."

  # create defaults
  for subDir in "${subDirs[@]}"
  do
    if [ -d "$comfyDir/$subDir" ]; then
      mv "$comfyDir/$subDir" "$comfyDir/$subDir-default"
    fi
  done
fi

# prepare sub dirs
for subDir in "${subDirs[@]}"
do
  echo "Preparing $dataDir/$subDir..."

  # create dir if not existing
  if [ ! -d "$dataDir/$subDir" ]; then
    echo " - Creating directory..."
    mkdir "$dataDir/$subDir"
  fi

  # link to data dir
  echo " - Updating symlink..."
  rm -rf $comfyDir/$subDir
  ln -s $dataDir/$subDir $comfyDir/$subDir

  # prepare dir if empty
  if [ "$(ls -A $dataDir/$subDir)" = "" ]; then
    # copy default files if possible
    if [ -d $comfyDir/$subDir-default ]; then
      echo " - Copy default files..."
      cp -R $comfyDir/$subDir-default/* $dataDir/$subDir/
    fi

    # initialize python venv
    if [ "$subDir" = "venv" ]; then
      echo " - Setup Python VENV..."
      python3 -m venv $dataDir/$subDir
    fi
  fi
done

source $dataDir/venv/bin/activate
cd "$comfyDir"

# Install comfyUI
if [ ! -e "$comfyDir/.comfy-setup-done" ]; then
  echo "Installing comfyUI..."

  echo " - Activate VENV and install requirements..."
  pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121
  pip install -r "$comfyDir/requirements.txt"

  echo " - Done."
  touch "$comfyDir/.comfy-setup-done"
fi

LAUNCH_ARGS="${LAUNCH_ARGS:-"--preview-method auto"}"
echo "+ python3 main.py $LAUNCH_ARGS --listen --port 8188"
python3 $comfyDir/main.py $LAUNCH_ARGS --listen --port 8188