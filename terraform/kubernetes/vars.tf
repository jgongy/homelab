variable "proxmox_node" {
  default = "hp-envy"
}

variable "network_cidr" {
  default = "172.20.0.0/16"
}

variable "template" {
  default = "debian-12-cloudinit-template"
}

variable "datastore" {
  default = "local-lvm"
}

variable "image_url" {
  default = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}

variable "bridge" {
  default = "vmbr200"
}

variable "user" {
  default = "debian"
}
