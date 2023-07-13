#!/bin/bash
dataDir=/data
webuiDir=/home/stable_diffusion/webui
set -e

# fix permissions (because docker mounts suck)
sudo chown "$(whoami):$(whoami)" -R $dataDir

# create models dir
if [ ! -d $dataDir/models ]; then
  mkdir -p $dataDir/models
fi
if [ -n "$(find $dataDir/models -prune -empty)" ]; then
  cp -r $webuiDir/models-default/* $dataDir/models
fi

# create configs dir
if [ ! -d $dataDir/configs ]; then
  mkdir -p $dataDir/configs
fi
if [ -n "$(find $dataDir/configs -prune -empty)" ]; then
  cp -r $webuiDir/configs-default/* $dataDir/configs
fi

# create embeddings dir
if [ ! -d $dataDir/embeddings ]; then
  mkdir -p $dataDir/embeddings
fi
if [ -n "$(find $dataDir/embeddings -prune -empty)" ]; then
  cp -r $webuiDir/embeddings-default/* $dataDir/embeddings
fi

# create venv dir
if [ ! -d $dataDir/venv ]; then
  mkdir -p $dataDir/venv
fi
if [ -n "$(find $dataDir/venv -prune -empty)" ]; then
  python3 -m venv $dataDir/venv
fi

# create repositories dir
if [ ! -d $dataDir/repositories ]; then
  mkdir -p $dataDir/repositories
fi

# create output dir
if [ ! -d $dataDir/outputs ]; then
  mkdir -p $dataDir/outputs
fi

# remove original models dir and link new one
ln -s $dataDir/models $webuiDir/models
ln -s $dataDir/outputs $webuiDir/outputs
ln -s $dataDir/configs $webuiDir/configs
ln -s $dataDir/embeddings $webuiDir/embeddings
ln -s $dataDir/repositories $webuiDir/repositories
ln -s $dataDir/venv $webuiDir/venv

# start webui
$webuiDir/webui.sh \
  --xformers \
  --listen \
  --port 7680