# Base image
FROM gcc:11.2.0

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Non-root user with sudo access
ARG USERNAME=default
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Env versioning
ARG GRPC_VERSION=v1.41.1
ARG HADOLINT_VERSION=v2.8.0

# Install apt deps
SHELL ["/bin/bash", "-c"]
RUN apt-get update \
  && apt-get -y install --no-install-recommends \
  apt-utils=2.2.4 \
  dialog=1.3-20201126-1 2>&1 \
  #
  # More apt deps
  && apt-get install -y --no-install-recommends \
  sudo=1.9.5p2-3 \
  build-essential=12.9 \
  autoconf=2.69-14 \
  libtool=2.4.6-15 \
  cmake=3.18.4-2 \
  pkg-config=0.29.2-1 \
  clang-format=1:11.0-51+nmu5 \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  #
  # Hadolint
  && wget --progress=dot:giga -O /bin/hadolint \
  https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
  && chmod +x /bin/hadolint \
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