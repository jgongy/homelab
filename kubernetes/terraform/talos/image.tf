locals {
  version = var.image.version
  schematic_id = module.talos_image.schematic_id

  update_version = coalesce(var.image.update_version, var.image.version)
  update_extensions = coalesce(var.image.update_extensions, var.image.extensions)

  update_schematic_id = module.talos_image_updated.schematic_id
}

module "talos_image" {
  source = "./talos-image"
  image = {
    version = var.image.version
    extensions = var.image.extensions
    platform = var.image.platform
    architecture = var.image.architecture
  }
}

module "talos_image_updated" {
  source = "./talos-image"
  image = {
    version = local.update_version
    extensions = local.update_extensions
    platform = var.image.platform
    architecture = var.image.architecture
  }
}

resource "proxmox_virtual_environment_download_file" "this" {
  for_each = toset(distinct([
    for k, v in var.nodes : join("_", [
      "${v.host_node}",
      "${v.update == true ? local.update_version : local.version}",
      "${join(",", v.update == true ? local.update_extensions : var.image.extensions)}",
      "${v.update == true ? "update" : "current"}",
    ])
  ]))

  node_name    = split("_", each.key)[0]
  content_type = "iso"
  datastore_id = var.image.proxmox_datastore

  file_name               = "talos-${split("_", each.key)[1]}-${var.image.platform}-${var.image.architecture}.img"
  # Proxmox can't decompress .xz files, and the Talos provider doesn't include
  # the .gz as a url by default, so we need to replace it manually.
  url                     = replace((endswith(each.key, "update") ? module.talos_image_updated.image_urls : module.talos_image.image_urls).disk_image, ".xz", ".gz")
  decompression_algorithm = "gz"
  overwrite               = true
}
