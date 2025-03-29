talos_cluster_config = {
    name            = "capi-bootstrap"
    gateway         = "10.0.0.1"
    service_subnet  = "10.96.0.0/12"
    pod_cidr_subnet = "10.244.0.0/16"
    talos_version   = "v1.9.5"
    k8s_version     = "v1.32.2"
    proxmox_cluster = "homelab"
    extra_manifests = []
}
