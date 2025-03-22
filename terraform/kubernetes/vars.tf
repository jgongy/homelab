variable "proxmox_node" {
  default = "hp-envy"
}

variable "network_cidr" {
  default = "172.0.11.0/22"
}

variable "gateway" {
  default = "10.0.0.1"
}

variable "template" {
  default = "debian-12-cloudinit-template"
}

variable "datastore" {
  default = "local-zfs"
}

variable "kubernetes_bridge" {
  default = "vmbr008"
}

variable "user" {
  default = "debian"
}

variable "cloud_iso" {
  default = "cloud.img"
}
