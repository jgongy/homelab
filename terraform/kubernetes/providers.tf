terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.5.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.70.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox.endpoint
  api_token = var.proxmox.api_token
  insecure = var.proxmox.insecure

  ssh {
    # TODO: Investigate whether private_key is necessary and agent can be set to true
    # agent    = true
    agent    = false
    private_key = file("~/.ssh/id_rsa")
    username = var.proxmox.username
  }
}
