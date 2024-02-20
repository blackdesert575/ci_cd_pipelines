#!/bin/bash

# refs
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html#amazon-linux-2-virtual-machine-boot
# https://forum.proxmox.com/threads/how-to-run-qcow2-file-in-proxmox.70371/

#  <vmid>: <integer> (100 - 999999999) 
vmid=104

qm create $vmid --name "amzn2" --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0 -cdrom local:iso/seed.iso
qm importdisk $vmid /var/lib/vz/template/iso/amzn2-kvm-2.0.20240109.0-x86_64.xfs.gpt.qcow2 local-lvm --format qcow2