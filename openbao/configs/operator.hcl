ui            = true

# The address for this node to receive intra-cluster traffic from other nodes.
# The TLS certificate is managed internally.
cluster_addr  = "https://127.0.0.1:8201"

# The address for this node to receive external traffic should other nodes
# be unable to internally forward requests.
api_addr      = "https://operator.openbao.internal.jackie.gg:8200"

listener "tcp" {
  address         = "operator.openbao.internal.jackie.gg:8200"

  # To reload, run 'sudo pkill -HUP openbao'
  tls_cert_file = "/etc/opnsense/tls/operator.openbao.internal.jackie.gg/fullchain.pem"
  tls_key_file  = "/etc/opnsense/tls/operator.openbao.internal.jackie.gg/key.pem"
  # tls_cipher_suites = "TLS_CHACHA20_POLY1305_SHA256"
}

storage "raft" {
  path    = "/homelab/storage/openbao/data"

  # Note: If the operator ever becomes an HA cluster, need to make this unique
  # per node.
  node_id = "openbao_operator"
}

# telemetry {
#   statsite_address = "127.0.0.1:8125"
#   disable_hostname = true
# }

