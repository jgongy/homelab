resource "terraform_data" "cilium_bootstrap_inline_manifests" {
  input = [
    {
      name     = "bootstrap"
      contents = file("${path.module}/cilium/bootstrap.yaml")
    },
    {
      name     = "values"
      contents = yamlencode({
        apiVersion = "v1"
        kind       = "ConfigMap"
        metadata = {
          name      = "cilium-values"
          namespace = "kube-system"
        }
        data = {
          "values.yaml" = templatefile(
            "${path.module}/cilium/values.yaml.tftpl",
            {
              pod_cidr_subnet = var.cluster.pod_cidr_subnet
            }
          )
        }
      })
    }
  ]
}

resource "talos_machine_secrets" "this" {
  talos_version = var.cluster.talos_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for k, v in var.nodes : v.internal_ip]
  endpoints            = [for k, v in var.nodes : v.external_ip if v.k8s_node_type == "controlplane"]
}

data "talos_machine_configuration" "this" {
  for_each         = var.nodes
  cluster_name     = var.cluster.name
  cluster_endpoint = "https://${var.cluster.endpoint}:6443"
  talos_version    = var.cluster.talos_version
  machine_type     = each.value.k8s_node_type
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches   = [
    templatefile(
      each.value.k8s_node_type == "controlplane"
        ? "${path.module}/k8s-node-config/control.yaml.tftpl"
        : "${path.module}/k8s-node-config/worker.yaml.tftpl",
      merge(
        {
          hostname = each.key
          internal_subnet  = var.cluster.internal_subnet
          k8s_version      = var.cluster.k8s_version
          cluster_dns_ips  = var.cluster.cluster_dns_ips
          node_labels      = jsonencode(merge(
            {
              "topology.kubernetes.io/region": var.cluster.proxmox_cluster
              "topology.kubernetes.io/zone": each.value.host_node
              "bgp-policy": "all"
            },
            each.value.node_labels
          ))
        },
        each.value.k8s_node_type == "controlplane" ? {
          cilium_values    = var.cilium.values
          cilium_bootstrap = var.cilium.bootstrap
          service_subnet   = var.cluster.service_subnet
          pod_cidr_subnet  = var.cluster.pod_cidr_subnet
          vip              = var.cluster.endpoint
          inline_manifests = jsonencode(terraform_data.cilium_bootstrap_inline_manifests.output)
          extra_manifests  = jsonencode(var.cluster.extra_manifests)
        } : { /* Worker values go here */ }
      )
    )
  ]
}

resource "talos_machine_configuration_apply" "this" {
  depends_on = [proxmox_virtual_environment_vm.this]
  for_each                    = var.nodes
  node                        = each.value.internal_ip
  endpoint                    = each.value.external_ip
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  lifecycle {
    replace_triggered_by = [proxmox_virtual_environment_vm.this[each.key]]
  }
}

resource "talos_machine_bootstrap" "this" {
  node                 = [for k, v in var.nodes : v.internal_ip if v.k8s_node_type == "controlplane"][0]
  # The machine.network.interfaces[].vip set by Talos Linux does not exist until
  # after bootstrapping, so we need to specify the external IP of the node
  # instead.
  endpoint             = [for k, v in var.nodes : v.external_ip if v.k8s_node_type == "controlplane"][0]
  client_configuration = talos_machine_secrets.this.client_configuration
}

data "talos_cluster_health" "this" {
  depends_on = [
    talos_machine_configuration_apply.this,
    talos_machine_bootstrap.this
  ]
  client_configuration = data.talos_client_configuration.this.client_configuration
  control_plane_nodes  = [for k, v in var.nodes : v.internal_ip if v.k8s_node_type == "controlplane"]
  worker_nodes         = [for k, v in var.nodes : v.internal_ip if v.k8s_node_type == "worker"]
  endpoints            = data.talos_client_configuration.this.endpoints
  timeouts = {
    read = "10m"
  }
}

data "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.this,
    data.talos_cluster_health.this
  ]
  node                 = [for k, v in var.nodes : v.internal_ip if v.k8s_node_type == "controlplane"][0]
  endpoint             = var.cluster.endpoint
  client_configuration = talos_machine_secrets.this.client_configuration
  timeouts = {
    read = "1m"
  }
}
