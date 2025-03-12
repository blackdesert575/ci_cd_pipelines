#!/usr/bin/env bash
set -euxo pipefail

docker build -f Dockerfile.python_test -t devops:test .
# docker run -it --name devops devops:test