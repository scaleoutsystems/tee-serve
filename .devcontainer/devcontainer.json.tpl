{
  "name": "devcontainer",
  "dockerFile": "Dockerfile",
  "context": "..",
  "remoteUser": "default",
  "extensions": [
    "ms-vscode.cpptools",
    "ms-vscode.cpptools-extension-pack",
    "ms-vscode.cpptools-themes",
    "exiasr.hadolint",
    "zxh404.vscode-proto3",
    "yzhang.markdown-all-in-one"
  ],
  "mounts": [
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind,consistency=default",
    // "source=/usr/src/linux-headers-***/arch/x86/include/uapi/asm/sgx.h,target=/usr/src/linux-headers-***/arch/x86/include/uapi/asm/sgx.h,type=bind,consistency=default", // For SGX machine, replace ***
  ],
  "runArgs": [
    "--privileged"
  ],
  // "overrideCommand": false, // For SGX machine
}