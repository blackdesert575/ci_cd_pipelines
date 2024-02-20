#!/bin/bash

genisoimage -output seed.iso -volid cidata -joliet -rock user-data meta-data
mv seed.iso /var/lib/vz/template/iso/