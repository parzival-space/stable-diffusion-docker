#!/bin/bash
set -e

dataDir=/data
webuiDir=/home/stable_diffusion/webui
subDirs=("configs" "embeddings" "models" "outputs" "repositories" "venv" "extensions")

# fix permissions (because docker mounts suck)
sudo chown "$(whoami):$(whoami)" -R $dataDir

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
  rm -rf $webuiDir/$subDir
  ln -s $dataDir/$subDir $webuiDir/$subDir

  # prepare dir if empty
  if [ "$(ls -A $dataDir/$subDir)" = "" ]; then
    # copy default files if possible
    if [ -d $webuiDir/$subDir-default ]; then
      echo " - Copy default files..."
      cp -R $webuiDir/$subDir-default/* $dataDir/$subDir/
    fi

    # initialize python venv
    if [ "$subDir" = "venv" ]; then
      echo " - Setup Python VENV..."
      python3 -m venv $dataDir/$subDir
    fi
  fi
done

# start webui
LAUNCH_ARGS="${LAUNCH_ARGS:-"--xformers --update-check --enable-insecure-extension-access"}"
$webuiDir/webui.sh $LAUNCH_ARGS --listen --port 7680