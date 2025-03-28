resource "proxmox_virtual_environment_vm" "this" {
  for_each = var.nodes

  node_name = each.value.host_node

  name        = each.key
  description = each.value.k8s_node_type == "controlplane" ? "Talos Control Plane" : "Talos Worker"
  tags        = each.value.k8s_node_type == "controlplane" ? ["k8s", "control-plane"] : ["k8s", "worker"]
  vm_id       = each.value.vm_id

  agent {
    enabled = true
  }
  stop_on_destroy = true

  initialization {
    datastore_id = each.value.datastore_id
    ip_config {
      ipv4 {
        address = "${each.value.external_ip}/${each.value.external_mask}"
        gateway = var.cluster.gateway
      }
    }
    ip_config {
      ipv4 {
        address = "${each.value.internal_ip}/${each.value.internal_mask}"
      }
    }
  }

  cpu {
    cores = each.value.cpu_cores
    type  = each.value.cpu_type
  }

  memory {
    dedicated = each.value.ram_dedicated
  }

  serial_device {
    device = "socket"
  }

  disk {
    datastore_id = each.value.datastore_id
    file_id      = proxmox_virtual_environment_download_file.this[join("_", [
                      "${each.value.host_node}",
                      "${each.value.update == true ? local.update_version : local.version}",
                      "${join(",", each.value.update == true ? local.update_extensions : var.image.extensions)}",
                      "${each.value.update == true ? "update" : "current"}",
                    ])].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 10
    file_format  = "raw"
  }

  dynamic "network_device" {
    for_each = var.bridges
    content {
      bridge = network_device.value.name
      model = network_device.value.model
    }
  }
}