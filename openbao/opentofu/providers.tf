terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.80.0"
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

