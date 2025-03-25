talos_cluster_config = {
    name            = "talos"
    endpoint        = "10.0.15.8"
    gateway         = "10.0.0.1"
    service_subnet  = "10.0.16.0/20"
    # Should match the address range of the bridge
    internal_subnet = "172.0.15.0/24"
    pod_cidr_subnet = "172.16.0.0/14"
    cluster_dns_ips = ["10.0.16.10"]
    talos_version   = "v1.9.5"
    k8s_version     = "v1.32.2"
    proxmox_cluster = "homelab"
    extra_manifests = [
      "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml",
      "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml",
      "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml",
      "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml",
      "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml",
      "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml"
    ]
}
