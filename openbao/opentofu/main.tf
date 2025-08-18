module "debian" {
  source = "../../opentofu/vm/cloud-init"

  providers = {
    proxmox = proxmox
  }

  network = {
    gateway = "10.0.14.1"
    vlan    = 14
    bridge  = "vmbr0"
  }

  nodes = {
    "openbao-00" = {
      host_node    = "beelink-eq14-1"
      description  = "OpenBao Instance"
      datastore    = "local-zfs"
      vm_id        = 14010

      cpu_cores    = 2
      cpu_type     = "x86-64-v2-AES"

      ram = {
        dedicated = 2048
        floating  = 2048
      }

      ip_address   = "10.0.14.10"
      ip_mask      = 24

      display = {
        device = "socket"
        vga    = "serial0"
      }

      disk = {
        interface = "virtio0"
        size      = 8 # in GiB
      }
    }
    "openbao-01" = {
      host_node    = "beelink-eq14-2"
      description  = "OpenBao Instance"
      datastore    = "local-zfs"
      vm_id        = 14011

      cpu_cores    = 2
      cpu_type     = "x86-64-v2-AES"

      ram = {
        dedicated = 2048
        floating  = 2048
      }

      ip_address   = "10.0.14.11"
      ip_mask      = 24

      display = {
        device = "socket"
        vga    = "serial0"
      }

      disk = {
        interface = "virtio0"
        size      = 8 # in GiB
      }
    }
    "openbao-02" = {
      host_node    = "hp-prodesk-600-1"
      description  = "OpenBao Instance"
      datastore    = "local-zfs"
      vm_id        = 14012

      cpu_cores    = 2
      cpu_type     = "x86-64-v2-AES"

      ram = {
        dedicated = 2048
        floating  = 2048
      }

      ip_address   = "10.0.14.12"
      ip_mask      = 24

      display = {
        device = "socket"
        vga    = "serial0"
      }

      disk = {
        interface = "virtio0"
        size      = 8 # in GiB
      }
    }
    "openbao-operator-00" = {
      host_node    = "hp-prodesk-600-2"
      description  = "OpenBao Instance"
      datastore    = "local-zfs"
      vm_id        = 14017

      cpu_cores    = 2
      cpu_type     = "x86-64-v2-AES"

      ram = {
        dedicated = 2048
        floating  = 2048
      }

      ip_address   = "10.0.14.17"
      ip_mask      = 24

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
    username           = "debian"
    datastore          = "local"

    content_type       = "import"
    url                = "https://cloud.debian.org/images/cloud/trixie/20250811-2201/debian-13-genericcloud-amd64-20250811-2201.qcow2"
    file_name          = "debian-13-genericcloud-amd64-for_openbao.qcow2"
    checksum           = "3a49caa6824dc4d567ab604ebddba34dfd3224b972ee6d10703e31f32d0262ae87d775fb8a952e3f0938962d316ce2f228ae52a8732bbe4def7869dd1b5e4e33"
    checksum_algorithm = "sha512"
  }
}

