#!/usr/bin/env bash

# set -euxo pipefail

uv run verify_iso.py

uv run verify_iso.py --help