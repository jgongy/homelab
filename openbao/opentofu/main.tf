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
    "openbao-ops" = {
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
    url                = "https://cloud.debian.org/images/cloud/bookworm/20250703-2162/debian-12-genericcloud-amd64-20250703-2162.qcow2"
    file_name          = "debian-12-genericcloud-amd64-for_openbao.qcow2"
    checksum           = "da702efced2cd98017790d0e00fee81f1e1404d3f990a4741f52e6f18bde9856d37799c053b3baa48805048a595d2a6a13c41b8287ec6f76ec27b7ef1b67a215"
    checksum_algorithm = "sha512"
  }
}

