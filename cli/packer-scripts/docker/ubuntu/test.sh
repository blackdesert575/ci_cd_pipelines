#!/usr/bin/env bash
set -euxo pipefail

packer init .
packer fmt .
packer validate .

packer build docker-ubuntu.pkr.hcl

docker images

docker run -it $IMAGE_ID