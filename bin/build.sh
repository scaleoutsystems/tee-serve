#!/bin/sh

# Env
PRJ_NAME="mdn-poc"
DEVCNT_TAG="local/mdn-poc:devcontainer"
CNT_TAG="local/mdn-poc:latest"

# Build devcontainer
>&2 echo "Building $DEVCNT_TAG"
docker build -t "$DEVCNT_TAG" . -f .devcontainer/Dockerfile

# Extract bins
>&2 echo "Extract binaries"
docker container create --name "${PRJ_NAME}-extract" "$DEVCNT_TAG"
docker container cp "${PRJ_NAME}-extract:/${PRJ_NAME}/build/agent" ./agent
docker container cp "${PRJ_NAME}-extract:/${PRJ_NAME}/build/user" ./user
docker container rm -f "${PRJ_NAME}-extract"

# Build container
>&2 echo "Building $DEVCNT_TAG" 
docker build --no-cache -t "$CNT_TAG" .