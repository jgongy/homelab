output "schematic_id" {
  value = talos_image_factory_schematic.this.id
}

output "image_urls" {
  value = data.talos_image_factory_urls.this.urls
}
