resource "proxmox_virtual_environment_network_linux_bridge" "bridge" {
  name       = var.bridge
  node_name  = var.proxmox_node
  address    = var.network_cidr
  vlan_aware = true
  comment    = "Kubernetes bridge"
}