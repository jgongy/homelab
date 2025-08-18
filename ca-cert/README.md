# Certificate Authority

Files used for generating an internal root certificate authority certificate.

## Generating the root/ca.key and intermediate/ca.key

```
openssl genpkey -aes256 -algorithm rsa -out root/ca.key
openssl genpkey -aes256 -algorithm rsa -out intermediate/ca.key
```

## Generating and viewing the root and intermediate certificates
### Root Certificate

```
openssl req                  \
    -config root/openssl.cnf \
    -new                     \
    -key root/ca.key         \
    -days 3650               \
    -sha512                  \
    -x509                    \
    -extensions v3_ca        \
    -subj "/C=US/ST=New York/L=New York/O=Homelab/OU=Homelab CA/CN=Homelab Root Certificate" \
    -out root/ca.crt
```

### Intermediate Certificate
```
openssl req                          \
    -config intermediate/openssl.cnf \
    -new                             \
    -key intermediate/ca.key         \
    -sha512                          \
    -subj "/C=US/ST=New York/L=New York/O=Homelab/OU=Homelab CA/CN=Homelab Intermediate Certificate Authority" \
    -out intermediate/ca.csr
```

### Sign intermediate certificate with the root certificate
```
openssl ca                         \
    -config root/openssl.cnf       \
    -extensions v3_intermediate_ca \
    -days 1825                     \
    -md sha512                     \
    -notext                        \
    -in intermediate/ca.csr        \
    -out intermediate/ca.crt
```

### Viewing
For viewing the certificate:
```
openssl x509 -in root/ca.crt -text
```

### Verify
```
openssl verify -CAfile root/ca.crt intermediate/ca.crt
```
### Verify intermediate chain
```
openssl verify -CAfile root/ca.crt -untrusted intermediate/ca.crt ../openbao/certificates/openbao-operator-00.crt
```

### Add root certificate to Debian VM
1. Add root certificate to `/usr/local/share/ca-certificates/`

2. Update certificates
```
sudo update-ca-certificates
```
