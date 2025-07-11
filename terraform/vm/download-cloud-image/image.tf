resource "proxmox_virtual_environment_download_file" "this" {
  node_name    = var.image.proxmox_node_name
  content_type = var.image.content_type
  datastore_id = var.image.datastore_id
  file_name    = var.image.file_name
  url          = var.image.url
}

