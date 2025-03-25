module "talos" {
  source = "./talos"

  providers = {
    proxmox = proxmox
  }
  cluster = var.talos_cluster_config

  bridges = {
    "vmbr008" = {
      host_node     = "hp-envy"
      # Should match the internal_subnet of the cluster
      address       = "172.0.15.0/24"
      vlan_aware    = true
      description   = "Kubernetes internal bridge"
    }
  }

  nodes = {
    "k-control-00" = {
      host_node     = "hp-envy"
      datastore_id  = "local-zfs"
      k8s_node_type = "controlplane"
      external_ip   = "10.0.15.0"
      external_mask = "20"
      internal_ip   = "172.0.15.0"
      internal_mask = "24"
      vm_id         = 200
      cpu_cores     = 2
      cpu_type      = "x86-64-v2-AES"
      ram_dedicated = 2048
      node_labels   = {}
    }
    "k-control-01" = {
      host_node     = "hp-envy"
      datastore_id  = "local-zfs"
      k8s_node_type = "controlplane"
      external_ip   = "10.0.15.1"
      external_mask = "20"
      internal_ip   = "172.0.15.1"
      internal_mask = "24"
      vm_id         = 201
      cpu_cores     = 2
      cpu_type      = "x86-64-v2-AES"
      ram_dedicated = 2048
      node_labels   = {}
    }
    "k-worker-00" = {
      host_node     = "hp-envy"
      datastore_id  = "local-zfs"
      k8s_node_type = "worker"
      external_ip   = "10.0.15.10"
      external_mask = "20"
      internal_ip   = "172.0.15.10"
      internal_mask = "24"
      vm_id         = 300
      cpu_cores     = 2
      cpu_type      = "x86-64-v2-AES"
      ram_dedicated = 2048
      node_labels   = {}
    }
  }

  image = {
    schematic = file("${path.module}/talos/image/schematic.yaml")
    version   = "v1.9.5"
    proxmox_datastore = "local"
  }


  cilium = {
    bootstrap = file("${path.module}/talos/cilium/bootstrap.yaml")
    values = file("${path.module}/talos/cilium/values.yaml.tftpl")
  }
}
