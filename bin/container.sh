#!/bin/bash

# Build container
docker build -f .devcontainer/Dockerfile -t tee-server .

# Run
docker run --rm -it -v $PWD:/pwd -w /pwd --privileged -u default \
	tee-server /bin/bash
