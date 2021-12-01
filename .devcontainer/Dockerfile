# Base image
ARG GCC_VERSION=11.2.0
FROM gcc:${GCC_VERSION}

# Env versioning
ARG HADOLINT_VERSION=v2.8.0
ARG GRPC_VERSION=v1.41.1
ARG CLANG_FORMAT_VERSION=1:11.0-51+nmu5

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
  build-essential \
  autoconf \
  libtool \
  pkg-config \
  clang-format=$CLANG_FORMAT_VERSION \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  #
  # Hadolint
  && wget --progress=dot:giga -O /bin/hadolint \
  https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
  && chmod +x /bin/hadolint \
  #
  # Install cmake
  && wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.19.6/cmake-3.19.6-Linux-x86_64.sh \
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
  # Create a non-root user to use if preferred
  && groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

# Set working directory
WORKDIR /home/$USERNAME

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog