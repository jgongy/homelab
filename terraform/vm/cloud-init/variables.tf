variable "network" {
  description = "Network settings for the nodes."
  type = object({
    gateway = string
    vlan    = number
    bridge  = string
  })
}

variable "nodes" {
  description = "Virtual machine configuration."
  type = map(object({
    host_node     = string
    description   = optional(string, "")
    datastore     = string
    vm_id         = number

    cpu_cores     = number
    cpu_type      = string

    # Set dedicated and floating equal to enable ballooning.
    ram           = object({
      dedicated = number
      floating  = optional(number, 0)
    })

    ip_address    = string
    ip_mask       = number
    mac_address   = optional(string, "")

    display       = object({
      device      = optional(string, "socket")
      vga         = optional(string, "serial0")
    })

    disk          = object({
      interface   = optional(string, "virtio0")
      size        = number
    })

    tags          = optional(list(string), [])
  }))
}

variable "image" {
  description = "Image"
  type = object({
    username           = string
    content_type       = string
    datastore          = string

    url                = string
    file_name          = string

    checksum           = optional(string, "")
    checksum_algorithm = optional(string, "")
  })
}

