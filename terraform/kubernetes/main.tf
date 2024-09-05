terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://ui.proxmox.local:8006/api2/json"
  pm_api_token_id     = "terraform@pam!terraform-api-key"
  pm_api_token_secret = "ae0cd304-bafd-46fb-b83c-7f4df2ded6b3"
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "kube-server" {
  count       = 1
  name        = "kube-server-0${count.index + 1}"
  vmid        = "20${count.index + 1}"
  target_node = var.proxmox_node
  clone       = var.template

  agent       = 1
  os_type     = "cloud-init"

  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 2048

  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  ipconfig0   = "ip=192.168.8.22${count.index + 1}/24,gw=192.168.8.1"
  ipconfig1   = "ip=192.168.200.22${count.index + 1}/24"

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = "10G"
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  network {
    model  = "virtio"
    bridge = "vmbr200"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "kube-agent" {
  count       = 2
  name        = "kube-agent-0${count.index + 1}"
  vmid        = "30${count.index + 1}"
  target_node = var.proxmox_node
  clone       = var.template

  agent       = 1
  os_type     = "cloud-init"

  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 2048

  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  ipconfig0   = "ip=192.168.8.23${count.index + 1}/24,gw=192.168.8.1"
  ipconfig1   = "ip=192.168.200.23${count.index + 1}/24"

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = "10G"
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  network {
    model  = "virtio"
    bridge = "vmbr200"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "kube-storage" {
  count       = 1
  name        = "kube-storage-0${count.index + 1}"
  vmid        = "40${count.index + 1}"
  target_node = var.proxmox_node
  clone       = var.template

  agent       = 1
  os_type     = "cloud-init"

  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 2048

  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  ipconfig0   = "ip=192.168.8.24${count.index + 1}/24,gw=192.168.8.1"
  ipconfig1   = "ip=192.168.200.24${count.index + 1}/24"

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = "20G"
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  network {
    model  = "virtio"
    bridge = "vmbr200"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}

