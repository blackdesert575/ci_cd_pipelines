#!/usr/bin/env bash
set -euxo pipefail

docker build -f Dockerfile.devops -t devops:v0.1 .
docker run -it --name devops devops:v0.1