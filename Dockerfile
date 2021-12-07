FROM debian:bullseye-slim

# Args
ARG PRJ_NAME="mdn-poc"
ARG TINI_VERSION="v0.19.0"

# Copy
COPY ./agent /usr/bin/agent
COPY ./resources /resources

# Install tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Entrypoint
ENTRYPOINT ["/usr/bin/tini"]
CMD ["/usr/bin/agent"]