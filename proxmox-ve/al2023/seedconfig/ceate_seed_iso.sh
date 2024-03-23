#!/bin/bash

# refs
# https://cloudinit.readthedocs.io/en/latest/reference/examples.html
# https://docs.aws.amazon.com/linux/al2023/ug/seed-iso.html

# mkisofs -output seed.iso -volid cidata -joliet -rock user-data meta-data
# mkisofs -output seed.iso -volid cidata -joliet -rock user-data meta-data network-config
genisoimage -output seed.iso -volid cidata -joliet -rock user-data meta-data
# genisoimage -output seed.iso -volid cidata -joliet -rock user-data meta-data network-config
mv seed.iso /var/lib/vz/template/iso/