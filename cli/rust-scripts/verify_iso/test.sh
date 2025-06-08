#!/usr/bin/env bash

# set -euxo pipefail

cargo build --release

./target/release/verify_iso

./target/release/verify_iso --help