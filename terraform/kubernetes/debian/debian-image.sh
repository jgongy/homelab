#!/bin/bash

IMAGE_URL="https://cloud.debian.org/images/cloud/bookworm/20250115-1993/debian-12-generic-amd64-20250115-1993.qcow2"
QCOW_FILE="cloud.qcow2"
IMG_FILE="cloud.img"
REMOTE_HOST="root@hp-envy"


# Download image.
wget -q $IMAGE_URL -O $QCOW_FILE

# Convert image from .qcow2 to .img because Proxmox does not
# support .qcow2 images.
qemu-img convert -f qcow2 -O raw $QCOW_FILE $IMG_FILE

# Install qemu-guest-agent for Proxmox to more easily manage VMs and iw
# for resolving wireless network connection issues on startup.
virt-customize -a $IMG_FILE --install qemu-guest-agent,iw

# Enable qemu-guest-agent on startup.
virt-customize -a $IMG_FILE --run-command 'systemctl enable qemu-guest-agent'
virt-customize -a $IMG_FILE --run-command 'systemctl start qemu-guest-agent'

# Move the customized image into the Proxmox image folder.
scp $IMG_FILE $REMOTE_HOST:/var/lib/vz/template/iso/$IMG_FILE

# Remove the ISO files.
rm $IMG_FILE
rm $QCOW_FILE
