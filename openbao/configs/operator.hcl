ui            = true

# The address for this node to receive intra-cluster traffic.
cluster_addr  = "https://127.0.0.1:8201"

# The address for this node to receive external traffic.
api_addr      = "https://127.0.0.1:8200"

listener "tcp" {
  address         = "127.0.0.1:8200"

  # To reload, run 'sudo pkill -HUP openbao'
  tls_cert_file = "/homelab/openbao/tls/openbao-node.bundle.pem"
  tls_key_file  = "/homelab/openbao/tls/openbao-node.key"
}

storage "raft" {
  path    = "/homelab/storage/openbao/data"
  node_id = "openbao_ops"
}

# telemetry {
#   statsite_address = "127.0.0.1:8125"
#   disable_hostname = true
# }

