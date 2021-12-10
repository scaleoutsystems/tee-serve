# Base image
FROM debian:bullseye

# Project name
ARG PRJ_NAME="mdn-poc"

# Env versioning
ARG HADOLINT_VERSION=v2.8.0
ARG GRPC_VERSION=v1.41.1
ARG CMAKE_VERSION=3.16.9
ARG TF_VERSION=2.6.2
ARG GRAMINE_HEAD=c9d75597b3586cddcef1604bab58d4780586a71c

# Non-root user with sudo access
ARG USERNAME=default
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install apt deps
SHELL ["/bin/bash", "-c"]
RUN apt-get update \
  && apt-get -y install --no-install-recommends \
  apt-utils \
  dialog 2>&1 \
  #
  # More apt deps
  && apt-get install -y --no-install-recommends \
  sudo \
  ca-certificates \
  wget \
  curl \
  git \
  vim \
  openssh-client \
  build-essential \
  autoconf \
  libtool \
  pkg-config \
  clang-format \
  googletest \
  libgtest-dev \
  autoconf \
  bison \
  gawk \
  ninja-build \
  python3 \
  python3-click \
  python3-jinja2 \
  python3-pip \
  #
  # Hadolint
  && wget --progress=dot:giga -O /bin/hadolint \
  https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
  && chmod +x /bin/hadolint \
  #
  # Install docker binary
  && curl -L https://download.docker.com/linux/static/stable/x86_64/docker-19.03.9.tgz | tar xvz docker/docker \
  && cp docker/docker /usr/local/bin \
  && rm -R docker \
  #
  # Install cmake
  && wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
  && sh cmake-linux.sh -- --skip-license \
  && rm cmake-linux.sh \
  #
  # gRPC
  && pushd /opt \
  && git clone --recurse-submodules -b $GRPC_VERSION https://github.com/grpc/grpc \
  && pushd grpc \
  && mkdir -p cmake/build \
  && pushd cmake/build \
  && cmake -DgRPC_INSTALL=ON \
  -DgRPC_BUILD_TESTS=OFF \
  ../.. \
  && make -j \
  && make install \
  && popd \
  && popd \
  && popd \
  #
  # TF lite
  && mkdir /opt/tensorflow \
  && git clone -b v${TF_VERSION} https://github.com/tensorflow/tensorflow.git /opt/tensorflow/tensorflow_src \
  && mkdir /opt/tensorflow/tflite_build \
  && pushd /opt/tensorflow/tflite_build \
  && cmake /opt/tensorflow/tensorflow_src/tensorflow/lite \
  && cmake --build . -j \
  && popd \
  #
  # SGX SDK
  && wget --progress=dot:giga https://download.01.org/intel-sgx/latest/linux-latest/distro/ubuntu20.04-server/sgx_linux_x64_sdk_2.15.101.1.bin \
  && chmod +x sgx_linux_x64_sdk_2.15.101.1.bin \
  && ./sgx_linux_x64_sdk_2.15.101.1.bin --prefix /opt/sgx-sdk \
  && rm sgx_linux_x64_sdk_2.15.101.1.bin \
  #
  # SGX PSW
  && wget --progress=dot:giga https://download.01.org/intel-sgx/sgx-linux/2.15.1/distro/ubuntu20.04-server/sgx_debian_local_repo.tgz \
  && tar xzvf sgx_debian_local_repo.tgz \
  && mv sgx_debian_local_repo /opt \
  && echo 'deb [trusted=yes] file:///opt/sgx_debian_local_repo focal main' >> /etc/apt/sources.list \
  && echo 'deb [trusted=yes] http://archive.ubuntu.com/ubuntu focal main' >> /etc/apt/sources.list \
  && sudo apt-get install --no-install-recommends \
  libsgx-urts \
  libsgx-launch \
  libsgx-epid \
  libsgx-quote-ex \
  libsgx-dcap-ql \
  # Gramine
  && python3 -m pip install --no-cache-dir 'meson>=0.55' 'toml>=0.10' \
  && git clone https://github.com/gramineproject/gramine.git /opt/gramine \
  && pushd /opt/gramine \
  && git checkout $GRAMINE_HEAD \
  && meson setup build/ --buildtype=release -Ddirect=enabled -Dsgx=disabled \
  && ninja -C build/ \
  && ninja -C build/ install \
  && popd \
  #
  # Create a non-root user to use if preferred
  && groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  #
  # User permissions
  && chown -R default:default /opt/gramine \
  #
  # Cleanup
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home/$USERNAME

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog