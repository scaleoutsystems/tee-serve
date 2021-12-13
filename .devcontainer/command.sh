#!/bin/bash
set -e

# Install build deps
>&2 echo "Installing Gramine build deps"
sudo apt-get update
sudo apt-get install -y \
    libcurl4-openssl-dev \
    libprotobuf-c-dev \
    protobuf-c-compiler \
    python3-pip \
    python3-protobuf

# Build gramine
>&2 echo "Build and install Gramine"
pushd /opt/gramine
meson setup build/ --buildtype=release -Ddirect=enabled -Dsgx=enabled --reconfigure
ninja -C build/
sudo ninja -C build/ install
popd

# Generate signer key
>&2 echo "Generate signer key"
mkdir -p "$HOME"/.config/gramine
openssl genrsa -3 -out "$HOME"/.config/gramine/enclave-key.pem 3072

# VSC hang command
/bin/sh -c "while sleep 1000; do :; done"
