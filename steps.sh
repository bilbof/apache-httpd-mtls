#!/bin/bash
set -eux
# Generate self-signed Root CA (ca.crt) with 10 year ttl
openssl genrsa -out ca.key 2048
# openssl ecparam -out ca.key -name prime256v1 -genkey
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3051 -out ca.pem -subj "/C=UK"
openssl req -new -sha256 -key ca.key -out ca.csr -subj "/C=UK"
openssl x509 -req -sha256 -days 3051 -in ca.csr -signkey ca.key -out ca.crt

# Generate Server cert that works with localhost
openssl ecparam -out server.key -name prime256v1 -genkey
openssl req -new -sha256 -key server.key -out server.csr -subj "/C=UK/CN=localhost"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 3050 -sha256

# Generate Client cert
openssl ecparam -out client.key -name prime256v1 -genkey
openssl req -new -sha256 -key client.key -out client.csr -subj "/C=UK"
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 3050 -sha256

# Verify certificates against Root CA
openssl verify -CAfile ca.crt server.crt
openssl verify -CAfile ca.crt client.crt

# Inspect the generated certs
# openssl x509 -in ca.crt -text -noout
# openssl x509 -in server.crt -text -noout
# openssl x509 -in client.crt -text -noout

# Remove certificate signing requests
rm *.csr

# Write out a message to index.html
echo "<p>Hi $(whoami), mTLS is working.</p>" > public-html/index.html

# Run apache httpd
docker build -t apache-httpd .
docker run -it -p 443:443 apache-httpd

# Outputs:
# - ca.crt      (root ca cert, used by httpd and the client)
# - ca.key      (used for signing certs)
# - server.crt  (used by httpd)
# - server.key  (used by httpd)
# - client.crt  (used by the client)
# - client.key  (used by the client)
