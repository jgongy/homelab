resource "proxmox_virtual_environment_vm" "storage" {
  count       = 1
  node_name   = var.proxmox_node

  name        = "k-storage-${count.index}"
  vm_id       = "40${count.index}"

  agent {
    enabled = false
  }
  stop_on_destroy = true

  initialization {

    ip_config {
      ipv4 {
        address = "10.20.200.24${count.index}/8"
        gateway = "10.0.0.1"
      }
    }
    ip_config {
      ipv4 {
        address = "172.20.200.24${count.index}/24"
      }
    }

    user_account {
      username = var.user
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
  }

  # scsihw      = "virtio-scsi-pci"
  # bootdisk    = "scsi0"

  disk {
    datastore_id = var.datastore
    file_id      = proxmox_virtual_environment_download_file.cloud-init-iso.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  network_device {
    model  = "virtio"
    bridge = "vmbr0"
  }

  network_device {
    model  = "virtio"
    bridge = var.bridge
  }

  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }
}
