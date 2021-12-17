#!/bin/bash

# Build container
docker build \
	-f .devcontainer/Dockerfile \
	-t tee-server \
	--build-arg DOCKER_USER=$(whoami) \
	--build-arg USER_UID=$UID \
	--build-arg $(id -u $USER) \
	.

# Run
docker run --rm -it -v $PWD:/pwd -w /pwd --privileged --net=host -u default \
	tee-server /bin/bash
