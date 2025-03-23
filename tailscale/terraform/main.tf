terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.70.1"
    }
  }
}

data "local_file" "ssh_public_key" {
  filename = "/root/.ssh/authorized_keys"
}

provider "proxmox" {
  endpoint       = "https://ui.proxmox.local:8006/"
  api_token      = "terraform@pve!provider=e73f8a19-403d-420d-94a7-7e85c2e792be"
  insecure       = true
  ssh {
    agent        = false
    private_key  = file("/root/.ssh/id_rsa")
    username     = "root"
  }
}

resource "proxmox_virtual_environment_vm" "tailscale" {
  count       = 1
  node_name   = var.proxmox_node
  name        = "tailscale-${count.index}"
  vm_id       = "14${count.index}"

  agent {
    enabled = true
  }
  stop_on_destroy = true

  initialization {
    datastore_id = var.datastore

    ip_config {
      ipv4 {
        address = "10.0.0.40/20"
        gateway = var.gateway
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

  disk {
    datastore_id  = var.datastore
    file_id       = "local:iso/cloud.img"
    interface     = "virtio0"
    iothread      = true
    discard       = "on"
    size          = 10
  }

  network_device {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network_device
    ]
  }
}

