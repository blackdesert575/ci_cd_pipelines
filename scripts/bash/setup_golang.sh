#!/usr/bin/env bash
set -eu

wget https://go.dev/dl/go1.26.2.linux-amd64.tar.gz

sha256sum go1.26.2.linux-amd64.tar.gz | grep "990e6b4bbba816dc3ee129eaeaf4b42f17c2800b88a2166c265ac1a200262282"

sudo sh -c "rm -rf /usr/local/go && tar -C /usr/local -xzf go1.26.2.linux-amd64.tar.gz"
