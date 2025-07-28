module "ssh_keys" {
  source = "./ssh-keys" # Path to your module
}

resource "proxmox_virtual_environment_vm" "this" {
  for_each = var.nodes

  node_name = each.value.host_node

  name        = each.key
  description = each.value.description
  tags        = each.value.tags
  vm_id       = each.value.vm_id

  agent {
    enabled = true
  }
  stop_on_destroy = true

  initialization {
    datastore_id = each.value.datastore
    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/${each.value.ip_mask}"
        gateway = var.network.gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
    user_account {
      username = var.image.username
      keys     = module.ssh_keys.parsed_ssh_keys
    }
  }

  cpu {
    cores = each.value.cpu_cores
    type  = each.value.cpu_type
  }

  memory {
    dedicated = each.value.ram.dedicated
    floating  = each.value.ram.floating
  }

  serial_device {
    device = each.value.display.device
  }

  vga {
    type = each.value.display.vga
  }

  disk {
    datastore_id = each.value.datastore
    import_from  = proxmox_virtual_environment_download_file.this[each.key].id
    interface    = each.value.disk.interface
    discard      = "on"
    size         = each.value.disk.size
  }

  network_device {
    bridge  = var.network.bridge
    vlan_id = var.network.vlan
  }
}
