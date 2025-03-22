resource "proxmox_virtual_environment_network_linux_bridge" "this" {
  for_each = var.bridges

  node_name  = each.value.host_node

  name       = each.key
  address    = each.value.address
  vlan_aware = each.value.vlan_aware
  comment    = each.value.description
}
