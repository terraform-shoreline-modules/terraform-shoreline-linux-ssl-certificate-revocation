#!/bin/bash

# Use certbot to renew certificate
certbot renew --cert-name "$CERTIFICATE_NAME"