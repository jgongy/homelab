resource "proxmox_virtual_environment_download_file" "this" {
  for_each = var.nodes

  node_name          = each.value.host_node
  content_type       = var.image.content_type
  datastore_id       = var.image.datastore

  file_name          = var.image.file_name
  url                = var.image.url
  overwrite          = false

  checksum           = var.image.checksum
  checksum_algorithm = var.image.checksum_algorithm
}

