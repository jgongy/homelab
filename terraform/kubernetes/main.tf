terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.63.0"
    }
  }
}

data "local_file" "ssh_public_key" {
  filename = "/root/.ssh/id_rsa.pub"
}

provider "proxmox" {
  endpoint      = "https://ui.proxmox.local:8006/"
  api_token     = "terraform@pve!provider=33b36136-9466-4f19-ac35-d4fd762c1a03"
  insecure      = true
  ssh {
    agent    = false
    private_key = file("/root/.ssh/id_rsa")
    username = "root"
  }
}

resource "proxmox_virtual_environment_download_file" "cloud-init-iso" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node

  url = var.image_url
  file_name    = "cloud-init.img"
}
