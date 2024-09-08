terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
    bpg-proxmox = {
      source = "bpg/proxmox"
      version = "0.63.0"
    }
  }
}

provider "bpg-proxmox" {
  endpoint      = "https://ui.proxmox.local:8006/"
  api_token     = "terraform@pve!provider=33b36136-9466-4f19-ac35-d4fd762c1a03"
  insecure      = true
  ssh {
    agent    = true
    username = "terraform"
  }
}

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr200" {
  provider   = bpg-proxmox
  name       = "vmbr200"
  node_name  = var.proxmox_node
  address    = var.network_cidr
  vlan_aware = true
  comment    = "Kubernetes bridge"
}

provider "proxmox" {
  pm_api_url          = "https://ui.proxmox.local:8006/api2/json"
  pm_api_token_id     = "terraform@pve!provider"
  pm_api_token_secret = "33b36136-9466-4f19-ac35-d4fd762c1a03"
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "kube-server" {
  provider    = proxmox
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
  provider    = proxmox
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
