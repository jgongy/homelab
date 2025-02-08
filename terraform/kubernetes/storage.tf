resource "proxmox_virtual_environment_vm" "storage" {
  count       = 0
  node_name   = var.proxmox_node

  name        = "k-storage-${count.index}"
  vm_id       = "40${count.index}"

  agent {
    enabled = true
  }
  stop_on_destroy = true

  initialization {
    datastore_id = var.datastore

    ip_config {
      ipv4 {
        address = "10.0.11.${count.index + 7}/20"
        gateway = var.gateway
      }
    }
    ip_config {
      ipv4 {
        address = "172.0.11.${count.index + 7}/22"
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

  serial_device {
    device = "socket"
  }

  # scsihw      = "virtio-scsi-pci"
  # bootdisk    = "scsi0"

  disk {
    datastore_id = var.datastore
    # file_id      = proxmox_virtual_environment_download_file.cloud-init-iso.id
    file_id      = "local:iso/cloud.img"
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
