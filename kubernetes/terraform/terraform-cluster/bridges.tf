resource "proxmox_virtual_environment_network_linux_bridge" "internal_network_bridge" {
  node_name  = "hp-envy"
  name       = "vmbr008"
  address       = "172.0.15.0/24"
  vlan_aware    = true
  comment = "Kubernetes internal bridge"
}
