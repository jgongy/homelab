###############
# things to double-check:
# 1. user directory
# 2. your SSH key location
# 3. which bridge you assign with the create line (currently set to vmbr100)
# 4. which storage is being utilized (script uses local-zfs)
###############

rm -f debian-12-generic-amd64.qcow2
wget -q https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2
sudo virt-customize -a debian-12-generic-amd64.qcow2 --install qemu-guest-agent
sudo virt-customize -a debian-12-generic-amd64.qcow2 --ssh-inject root:file:~/.ssh/id_rsa.pub
sudo qm destroy 5000
sudo qm create 5000 --name "debian-12-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr100
sudo qm importdisk 5000 debian-12-generic-amd64.qcow2 local-lvm
sudo qm set 5000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-5000-disk-0
sudo qm set 5000 --boot c --bootdisk scsi0
sudo qm set 5000 --ide2 local-lvm:cloudinit
sudo qm set 5000 --serial0 socket --vga serial0
sudo qm set 5000 --agent enabled=1
# sudo qm set 5000 --sshkeys /tmp/sshkey.pub
sudo qm template 5000
rm -f debian-12-generic-amd64.qcow2
echo "next up, clone VM, then expand the disk"
echo "you also still need to copy ssh keys to the newly cloned VM"

