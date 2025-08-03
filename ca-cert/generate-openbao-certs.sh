#!/bin/bash

####
# Generates the CSR and CRT files for OpenBao nodes. Should be run in the
# homelab/ca-cert/ directory.
####

CA_CERT_DIR="."
CERT_DIR="../openbao/certificates"

function gen_csr() {
    # Check if a hostname was provided
    if [[ -z "$1" ]]; then
        echo "Error: Missing node name (e.g., 'node-00')."
        return 1
    fi

    local NODE_NAME="$1"
    local BASE_SUBJ="/C=US/ST=New York/L=New York/O=Homelab/OU=Homelab CA"
    openssl req                                           \
        -config "${CA_CERT_DIR}/intermediate/openssl.cnf" \
        -new                                              \
        -key "${CERT_DIR}/${NODE_NAME}.key"               \
        -subj "${BASE_SUBJ}/CN=${NODE_NAME}.openbao.internal.jackie.gg" \
        -out "${CERT_DIR}/openbao-${NODE_NAME}.csr"
}

function gen_crt() {
    # Check if a hostname was provided
    if [[ -z "$1" ]]; then
        echo "Error: Missing node name (e.g., 'node-00')."
        return 1
    fi

    if [[ -z "$2" ]]; then
        echo "Error: Missing intermediate CA key passphrase."
        return 1
    fi

    local NODE_NAME="$1"
    local INT_CA_KEY_PASS="$2"
    local INT_CA_CERT_PATH="${CA_CERT_DIR}/intermediate/ca.crt"
    local LEAF_CERT_PATH="${CERT_DIR}/openbao-${NODE_NAME}.crt"

    openssl ca                                             \
        -config  "${CA_CERT_DIR}/intermediate/openssl.cnf" \
        -days 90                                           \
        -extensions svr_cert                               \
        -notext                                            \
        -passin "pass:${INT_CA_KEY_PASS}"                  \
        -in "${CERT_DIR}/openbao-${NODE_NAME}.csr"         \
        -out "${LEAF_CERT_PATH}"
    
    # Create the cert bundle
    cat "${LEAF_CERT_PATH}" "${INT_CA_CERT_PATH}" > "${CERT_DIR}/openbao-${NODE_NAME}.bundle.pem"
}

gen_csr "node-00"
gen_csr "node-01"
gen_csr "node-02"
gen_csr "operator-00"

read -s -p "Intermediate ca.key passphrase: " PASS
gen_crt "node-00" "${PASS}"
gen_crt "node-01" "${PASS}"
gen_crt "node-02" "${PASS}"
gen_crt "operator-00" "${PASS}"
