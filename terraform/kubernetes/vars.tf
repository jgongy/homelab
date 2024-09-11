variable "proxmox_node" {
  default = "hp-envy"
}

variable "network_cidr" {
  default = "172.0.11.0/24"
}

variable "gateway" {
  default = "10.0.0.1"
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
  default = "vmbr008"
}

variable "user" {
  default = "debian"
}
