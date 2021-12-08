#!/bin/bash
CNT_TAG="local/mdn-poc:latest"
CNT_NAME="mdn-poc"
docker run -it -p 50051:50051 -d --name mdn-poc $CNT_TAG