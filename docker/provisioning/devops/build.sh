#!/usr/bin/env bash
set -euxo pipefail

docker build -f Dockerfile.python_test -t devops:test .
# docker run -it --name devops devops:test

# docker compose build --no-cache

# docker compose up -d

# check process
ps -p 1 -o cmd=