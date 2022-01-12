# Lightweight model serving in TEE
Lightweight model serving in [Intel SGX TEE](https://www.intel.com/content/www/us/en/developer/tools/software-guard-extensions/overview.html) using [Gramine](https://grapheneproject.io) and [TensorFlow lite](https://www.tensorflow.org/lite) C++ API.

## Table of contents
- [Lightweight model serving in TEE](#lightweight-model-serving-in-tee)
  - [Table of contents](#table-of-contents)
  - [Quickstart](#quickstart)
  - [Building the binaries](#building-the-binaries)
  - [Running in direct mode (without SGX)](#running-in-direct-mode-without-sgx)
  - [Running in SGX](#running-in-sgx)
  - [Getting access to SGX](#getting-access-to-sgx)

## Quickstart

The only prerequisite to run this proof of concept is https://docker.io. Once you have installed docker you can clone this repository, locate into it and launch the environment as if follows.

```console
$ bin/launch.sh
```

This is going to build and start a container with all of the required dependencies to build and run the codebase.

## Building the binaries

To build the `server` and the `client` binaries you can run:

```console
$ bin/build.sh
```

This command is going to build the binaries, sign the `server` and generate other necessary Gramine files.

## Running in direct mode (without SGX)
The `gramine-direct` command can be used for testing purposed (or if a SGX machine is not available). To start the server in this manner you can run:

```console
$ gramine-direct server resources/plain/model.tflite
```

> **Note** `server` is the server executable and `resources/plain/model.tflite` is a TensorFlow lite model.

To test the server you can open a new console and run e.g. `./client 0.5`.

## Running in SGX
The `gramine-sgx` command can be used run the server in the SGX enclave as it follows.

```console
$ gramine-sgx server resources/model.tflite
```

> **Note** `server` is the server executable and `resources/model.tflite` is an encrypted TensorFlow lite model.

To test the server you can open a new console and run e.g. `./client 0.5`.

## Getting access to SGX
Azure offers Intel SGX instances that you can get on deman: https://azure.microsoft.com/en-us/solutions/confidential-compute.
