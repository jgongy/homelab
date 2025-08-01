module "talos" {
  source = "../talos"

  providers = {
    proxmox = proxmox
  }
  cluster = var.talos_cluster_config

  bridges = [
    {
      name = "vmbr0"
      model = "virtio"
    },
  ]

  nodes = {
    "k-capi-bootstrap" = {
      host_node     = "hp-envy"
      datastore_id  = "local-zfs"
      k8s_node_type = "controlplane"
      external_ip   = "10.0.15.254"
      external_mask = "20"
      vm_id         = 200
      cpu_cores     = 2
      cpu_type      = "x86-64-v2-AES"
      ram_dedicated = 3072
      node_labels   = {}
    }
  }

  image = {
    architecture = "amd64"
    platform = "nocloud"
    version   = "v1.9.5"
    extensions = [
      # For Proxmox to better control the virtual machine
      "siderolabs/qemu-guest-agent",

      # Needed to support Kubernetes interactions with Intel encoding and
      # decoding for services like Plex or Jellyfin
      # "siderolabs/i915-ucode",
      "siderolabs/intel-ucode",
    ]
    proxmox_datastore = "local"
  }


  cilium = {
    bootstrap = file("${path.module}/../talos/cilium/bootstrap.yaml")
    values = file("${path.module}/../talos/cilium/values.yaml.tftpl")
  }
}
