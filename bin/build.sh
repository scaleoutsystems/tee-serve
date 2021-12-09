#!/bin/sh

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