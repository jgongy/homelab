###############
# things to double-check:
# 1. user directory
# 2. your SSH key location
# 3. which bridge you assign with the create line (currently set to vmbr100)
# 4. which storage is being utilized (script uses local-zfs)
###############

IMAGE="debian-12-generic-amd64.qcow2"
IMAGE_URL="https://cloud.debian.org/images/cloud/bookworm/latest/$IMAGE"
SSH_KEY_PATH="/root/.ssh/id_rsa.pub"
VMID="5000"
TPL_NAME="debian-12-cloudinit-template"


rm -f $IMAGE
wget -q $IMAGE_URL
sudo virt-customize -a $IMAGE --install qemu-guest-agent
sudo virt-customize -a $IMAGE --ssh-inject root:file:$SSH_KEY_PATH
sudo qm destroy $VMID
sudo qm create $VMID --name $TPL_NAME --memory 2048 --cores 2 --net0 virtio,bridge=vmbr100
sudo qm importdisk $VMID $IMAGE local-lvm
sudo qm set $VMID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-5000-disk-0
sudo qm set $VMID --boot c --bootdisk scsi0
sudo qm set $VMID --ide2 local-lvm:cloudinit
sudo qm set $VMID --serial0 socket --vga serial0
sudo qm set $VMID --agent enabled=1
# sudo qm set $VMID --sshkeys $SSH_KEY_PATH
sudo qm template $VMID
rm -f $IMAGE

