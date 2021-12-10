#!/bin/sh
set -e

# Build binaries
cmake --no-warn-unused-cli \
-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE \
-DCMAKE_BUILD_TYPE:STRING=Debug \
-DCMAKE_C_COMPILER:FILEPATH=/usr/bin/x86_64-linux-gnu-gcc-10 \
-DCMAKE_CXX_COMPILER:FILEPATH=/usr/bin/x86_64-linux-gnu-g++-10 \
-H$PWD \
-B$PWD/build \
-G Ninja
cmake --build $PWD/build --config Debug --target all -j $(nproc)
cp build/agent build/user .

# Generate SGX-related files
gramine-manifest -Dlog_level=debug agent.manifest.template agent.manifest
gramine-sgx-sign --key /home/default/.config/gramine/enclave-key.pem --manifest agent.manifest --output agent.manifest.sgx
gramine-sgx-get-token --output agent.token --sig agent.sig