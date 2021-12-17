#!/bin/sh
set -e

# Build binaries
cmake --no-warn-unused-cli \
-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE \
-DCMAKE_BUILD_TYPE:STRING=Debug \
-DCMAKE_C_COMPILER:FILEPATH=/usr/bin/x86_64-linux-gnu-gcc-11 \
-DCMAKE_CXX_COMPILER:FILEPATH=/usr/bin/x86_64-linux-gnu-g++-11 \
-H$PWD \
-B$PWD/build \
-G Ninja
cmake --build $PWD/build --config Debug --target all -j $(nproc)
cp build/server build/client .

# Generate sig key if necessary
if [ ! -e "$file" ]; then
    mkdir -p $HOME/.gramine
    openssl genrsa -3 -out $HOME/.gramine/enclave-key.pem 3072
fi

# Generate SGX-related files
gramine-manifest -Dlog_level=debug server.manifest.template server.manifest
gramine-sgx-sign --key $HOME/.gramine/enclave-key.pem --manifest server.manifest --output server.manifest.sgx
gramine-sgx-get-token --output server.token --sig server.sig