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
  endpoint      = "https://ui.proxmox.local:8006/"
  api_token     = "terraform@pve!provider=e73f8a19-403d-420d-94a7-7e85c2e792be"
  insecure      = true
  ssh {
    agent    = false
    private_key = file("/root/.ssh/id_rsa")
    username = "root"
  }
}

