#!/usr/bin/env bash
set -euxo pipefail

docker images | awk '$1 == "<none>" || $2 == "<none>" { print $3 }' | xargs -r docker rmi