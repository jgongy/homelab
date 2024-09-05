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

resource "proxmox_vm_qemu" "gngnde" {
  count       = 1
  name        = "gngnde-${count.index + 1}"
  target_node = var.proxmox_node
  clone       = var.template
  cores       = 2
  memory      = 2048
  ipconfig0   = "ip=192.168.8.11${count.index + 1}/24,gw=10.98.1.1"
}

