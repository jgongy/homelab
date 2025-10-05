module "debian" {
  source = "../../opentofu/vm/cloud-init"

  providers = {
    proxmox = proxmox
  }

  network = {
    gateway = "10.0.0.1"
    vlan    = 99
    bridge  = "vmbr0"
  }

  nodes = {
    "technitium-00" = {
      host_node    = "beelink-eq14-1"
      description  = "Technitium Instance"
      datastore    = "local-zfs"
      vm_id        = 120

      cpu_cores    = 1
      cpu_type     = "x86-64-v2-AES"

      ram = {
        dedicated = 1536
        floating  = 1536
      }

      ip_address   = "10.0.0.5"
      ip_mask      = 23

      display = {
        device = "socket"
        vga    = "serial0"
      }

      disk = {
        interface = "virtio0"
        size      = 8 # in GiB
      }
    }

    "technitium-01" = {
      host_node    = "beelink-eq14-1"
      description  = "Technitium Instance"
      datastore    = "local-zfs"
      vm_id        = 121

      cpu_cores    = 1
      cpu_type     = "x86-64-v2-AES"

      ram = {
        dedicated = 1536
        floating  = 1536
      }

      ip_address   = "10.0.0.6"
      ip_mask      = 23

      display = {
        device = "socket"
        vga    = "serial0"
      }

      disk = {
        interface = "virtio0"
        size      = 8 # in GiB
      }
    }
  }

  image = {
    username           = "admin"
    datastore          = "local"

    content_type       = "import"
    url                = "https://cloud.debian.org/images/cloud/trixie/20250811-2201/debian-13-genericcloud-amd64-20250811-2201.qcow2"
    file_name          = "debian-13-genericcloud-amd64-for_technitium.qcow2"
    checksum           = "3a49caa6824dc4d567ab604ebddba34dfd3224b972ee6d10703e31f32d0262ae87d775fb8a952e3f0938962d316ce2f228ae52a8732bbe4def7869dd1b5e4e33"
    checksum_algorithm = "sha512"
  }
}

