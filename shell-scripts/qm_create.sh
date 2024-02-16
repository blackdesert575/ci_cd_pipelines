#!/bin/bash

qm create 200 --name vyos --memory 2048 --net0 virtio,bridge=vmbr0 --ide2 media=cdrom,file=local:iso/live-image-amd64.hybrid.iso --virtio0 local-lvm:15