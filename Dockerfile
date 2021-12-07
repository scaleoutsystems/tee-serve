FROM debian:bullseye-slim

# Args
ARG PRJ_NAME="mdn-poc"

# Copy
COPY ./agent /usr/bin/agent
COPY ./resources /resources

# Entrypoint
ENTRYPOINT ["/usr/bin/agent"]