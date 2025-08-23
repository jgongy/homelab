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

    local BASE_SUBJ="/C=US/ST=New York/L=New York/O=Homelab/OU=Homelab CA"
    local BASE_URL="openbao.internal.jackie.gg"

    local PURPOSE
    local COMMON_NAME
    if [[ "$1" == node* ]]; then
        PURPOSE="cluster"
        COMMON_NAME="${BASE_URL}"
    else
        PURPOSE="operator"
        COMMON_NAME="operator.${BASE_URL}"
    fi

    local SUBJECT_ALT_NAME
    SUBJECT_ALT_NAME="DNS:${COMMON_NAME}"
    for arg in "$@"; do
      SUBJECT_ALT_NAME+=", DNS:${arg}.${BASE_URL}"
    done

    echo "Generating CSR for ${PURPOSE}."
    openssl req                                        \
        -new                                           \
        -key "${CERT_DIR}/${PURPOSE}.key"              \
        -subj "${BASE_SUBJ}/CN=${COMMON_NAME}"         \
        -addext "subjectAltName = ${SUBJECT_ALT_NAME}" \
        -out "${CERT_DIR}/openbao-${PURPOSE}.csr"
}

function gen_crt() {
    # Check if a hostname was provided
    if [[ -z "$1" ]]; then
        echo "Error: Missing purpose (e.g., 'cluster')."
        return 1
    fi

    if [[ -z "$2" ]]; then
        echo "Error: Missing intermediate CA key passphrase."
        return 1
    fi

    local PURPOSE="$1"
    local INT_CA_KEY_PASS="$2"
    local INT_CA_CERT_PATH="${CA_CERT_DIR}/intermediate/ca.crt"
    local LEAF_CERT_PATH="${CERT_DIR}/openbao-${PURPOSE}.crt"

    echo "Generating certificate for ${PURPOSE}."
    openssl ca                                             \
        -config  "${CA_CERT_DIR}/intermediate/openssl.cnf" \
        -days 90                                           \
        -extensions svr_cert                               \
        -notext                                            \
        -passin "pass:${INT_CA_KEY_PASS}"                  \
        -in "${CERT_DIR}/openbao-${PURPOSE}.csr"         \
        -out "${LEAF_CERT_PATH}"
    
    # Create the cert bundle
    cat "${LEAF_CERT_PATH}" "${INT_CA_CERT_PATH}" > "${CERT_DIR}/openbao-${PURPOSE}.bundle.pem"
}

gen_csr "node-00" "node-01" "node-02"
gen_csr "operator-00"

read -s -p "Intermediate ca.key passphrase: " PASS
gen_crt "cluster" "${PASS}"
gen_crt "operator" "${PASS}"
