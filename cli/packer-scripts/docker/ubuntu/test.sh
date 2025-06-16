#!/usr/bin/env bash
set -euxo pipefail

packer init .
packer fmt .
packer validate .