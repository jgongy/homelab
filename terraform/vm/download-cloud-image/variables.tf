variable "image" {
  description       = "Cloud image configuration"
  type = object({
    proxmox_node_name = string
    content_type      = string
    datastore_id      = string
    url               = string
    file_name         = optional(string)
  })
}

