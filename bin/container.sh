#!/bin/bash

# Build container
docker build -f .devcontainer/Dockerfile -t tee-server .

# Run
docker --rm -it tee-server -v $PWD:/pwd -w /pwd --privileged /bin/bash