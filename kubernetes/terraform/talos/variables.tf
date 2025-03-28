variable "cluster" {
  description = "Cluster configuration"
  type = object({
    name            = string
    endpoint        = string
    gateway         = string
    internal_subnet = string
    service_subnet  = string
    pod_cidr_subnet = string

    # Should be an address in the service_subnet, found via
    # the clusterIP field in 'kubectl get svc -n kube-system kube-dns`
    # If not set, `cilium connectivity test --debug` fails because it tries to
    # connect to the default clusterDNS IP of `10.96.0.10`.
    # TODO: Investigate whether there's a way this doesn't need to be set
    # manually.
    cluster_dns_ips = optional(list(string), [])
    talos_version   = string
    k8s_version     = string
    proxmox_cluster = string
    extra_manifests = optional(list(string))
  })
}

variable "bridges" {
  description = "Affects the network devices Talos VMs have interfaces for"
  type = list(object({
    model = string
    name = string
  }))
}

variable "nodes" {
  description = "Configuration for Kubernetes nodes"
  type = map(object({
    host_node     = string
    k8s_node_type = string
    datastore_id  = string
    external_ip   = string
    external_mask = string
    internal_ip   = string
    internal_mask = string
    mac_address   = optional(string, "")
    vm_id         = number
    cpu_cores     = number
    cpu_type      = string
    ram_dedicated = number
    update        = optional(bool, false)
    node_labels   = map(string)
  }))
}

variable "image" {
  description = "Talos image configuration"
  type = object({
    architecture = string
    platform = string
    extensions = list(string)
    update_extensions = optional(list(string))
    version   = string
    update_version = optional(string)
    proxmox_datastore = string
  })
}

variable "cilium" {
  description = "Cilium configuration"
  type = object({
    bootstrap = string
    values  = string
  })
}
