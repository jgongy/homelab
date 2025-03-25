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