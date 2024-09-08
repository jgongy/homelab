variable "proxmox_node" {
  default = "hp-envy"
}

variable "network_cidr" {
  default = "192.168.200.10/24"
}

variable "template" {
  default = "debian-12-cloudinit-template"
}
