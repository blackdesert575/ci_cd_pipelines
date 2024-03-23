#!/bin/bash

# refs:
# https://docs.aws.amazon.com/linux/al2023/ug/kvm-supported-configurations.html#kvm-host-requirements
# https://forum.proxmox.com/threads/how-to-run-qcow2-file-in-proxmox.70371/
# kvm qcow2
# https://cdn.amazonlinux.com/al2023/os-images/2023.4.20240319.1/kvm/

#  <vmid>: <integer> (100 - 999999999) 
vmid=105
al2023_qcow2=al2023-kvm-2023.3.20240205.2-kernel-6.1-x86_64.xfs.gpt.qcow2

qm create $vmid --name "al2023" --memory 4096 --cores 2 --cpu cputype=host --net0 virtio,bridge=vmbr0 -cdrom local:iso/seed.iso
qm importdisk $vmid /var/lib/vz/template/iso/$al2023_qcow2 local-lvm --format qcow2