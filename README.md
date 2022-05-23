## Apache HTTPD mTLS setup example

Demonstrates how to set up mTLS with Apache httpd using a self-signed root CA certificate.
This demo isn't intended for production usage.

### Run locally

This script:

1. Provisions certs: generates a root ca, self-signs it, generates client and server certs and signs them with the root CA cert.
2. Runs HTTPD on localhost:443 using the generated server cert

```
./steps.sh
```

You can test the server is configured properly with the following command:

```
curl https://localhost --cert client.crt --key client.key --cacert ca.crt
```

