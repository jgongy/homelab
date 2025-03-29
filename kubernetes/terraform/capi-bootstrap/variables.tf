variable "proxmox" {
  type = object({
    name         = string
    cluster_name = string
    endpoint     = string
    insecure     = bool
    username     = string
    api_token    = string
  })
  sensitive = true
}

variable "talos_cluster_config" {
  description = "Cluster configuration"
  type = object({
    name            = string
    gateway         = string
    service_subnet  = string
    pod_cidr_subnet = string
    talos_version   = string
    k8s_version     = string
    proxmox_cluster = string
    extra_manifests = optional(list(string))
  })
}