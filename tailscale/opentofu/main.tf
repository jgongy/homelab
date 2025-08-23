module "debian" {
  source = "../../opentofu/vm/cloud-init"

  providers = {
    proxmox = proxmox
  }

  network = {
    gateway = "10.0.2.1"
    vlan    = 2
    bridge  = "vmbr0"
  }

  nodes = {
    "tailscale-00" = {
      host_node    = "hp-envy"
      description  = "Tailscale"
      datastore = "local-zfs"
      vm_id        = 150

      cpu_cores    = 1
      cpu_type     = "x86-64-v2-AES"

      ram = {
        dedicated = 768
        floating  = 768
      }

      ip_address   = "10.0.2.150"
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
    username           = "debian"
    datastore          = "local"

    content_type       = "import"
    url                = "https://cloud.debian.org/images/cloud/bookworm/20250703-2162/debian-12-genericcloud-amd64-20250703-2162.qcow2"
    file_name          = "debian-12-genericcloud-amd64-for_tailscale.qcow2"
    checksum           = "da702efced2cd98017790d0e00fee81f1e1404d3f990a4741f52e6f18bde9856d37799c053b3baa48805048a595d2a6a13c41b8287ec6f76ec27b7ef1b67a215"
    checksum_algorithm = "sha512"
  }
}

