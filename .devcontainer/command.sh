#!/bin/bash
set -e

# Install build deps
>&2 echo "Installing Gramine build deps"
apt-get update
apt-get install -y \
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
ninja -C build/ install
popd

# Generate signer key
>&2 echo "Generate signer key"
sudo -u default mkdir -p /home/default/.config/gramine
sudo -u default openssl genrsa -3 -out /home/default/.config/gramine/enclave-key.pem 3072

# VSC hang command
while sleep 1000; do :; done
