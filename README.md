
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# SSL Certificate Revocation
---

An SSL Certificate Revocation incident refers to an event where the SSL certificate for a particular instance is found to be revoked or invalid. This can cause security issues and disrupt the availability of the service, as clients may not be able to establish a secure connection with the instance. Resolving this incident typically involves renewing or replacing the SSL certificate for the affected instance.

### Parameters
```shell
export PORT="PLACEHOLDER"

export INSTANCE="PLACEHOLDER"

export CERTIFICATE_FILE="PLACEHOLDER"

export PATH_TO_CA_BUNDLE_FILE="PLACEHOLDER"

export NAME_OF_SSL_CERTIFICATE_AUTHORITY="PLACEHOLDER"

export CERTIFICATE_NAME="PLACEHOLDER"
```

## Debug

### Check the SSL certificate status of an instance
```shell
openssl s_client -connect ${INSTANCE}:${PORT} -tls1_2
```

### Check the SSL certificate validity period
```shell
openssl x509 -in ${CERTIFICATE_FILE} -noout -dates
```

### Check the SSL certificate issuer
```shell
openssl x509 -in ${CERTIFICATE_FILE} -noout -issuer
```

### Check the SSL certificate subject
```shell
openssl x509 -in ${CERTIFICATE_FILE} -noout -subject
```

### Check the SSL certificate chain
```shell
openssl s_client -connect ${INSTANCE}:${PORT} -tls1_2 -showcerts
```

### Check the SSL/TLS protocol version
```shell
openssl s_client -connect ${INSTANCE}:${PORT} -tls1_2 -msg
```

### Check the SSL/TLS handshake process
```shell
openssl s_client -connect ${INSTANCE}:${PORT} -tls1_2 -state -debug
```

### Check the SSL/TLS cipher suite
```shell
openssl s_client -connect ${INSTANCE}:${PORT} -tls1_2 -cipher
```

### Check the SSL/TLS certificate revocation status
```shell
openssl s_client -connect ${INSTANCE}:${PORT} -tls1_2 -crlf -status
```

### The SSL certificate for the instance expired and was not renewed in a timely manner.
```shell


#!/bin/bash



# Define instance and certificate variables

INSTANCE=${INSTANCE}

CERTIFICATE=${CERTIFICATE_FILE}



# Check if certificate has expired

if openssl x509 -checkend 0 -noout -in $CERTIFICATE; then

    echo "Certificate for $INSTANCE has not expired."

else

    echo "Certificate for $INSTANCE has expired."

fi


```

### The SSL certificate was issued by an untrusted or compromised certificate authority.
```shell


#!/bin/bash



# Define variables

INSTANCE=${INSTANCE}

CERT_FILE=${CERTIFICATE_FILE}

CERT_AUTHORITY=${NAME_OF_SSL_CERTIFICATE_AUTHORITY}



# Check if certificate is valid

openssl verify -CAfile ${PATH_TO_CA_BUNDLE_FILE} $CERT_FILE



# Check if certificate was issued by trusted authority

openssl x509 -noout -issuer $CERT_FILE | grep -q $CERT_AUTHORITY

if [ $? -ne 0 ]; then

    echo "Certificate was not issued by trusted authority: $CERT_AUTHORITY"

    exit 1

fi



echo "Certificate is valid and was issued by trusted authority: $CERT_AUTHORITY"

exit 0


```

## Repair

### Renew the SSL certificate: The first step to resolving an SSL certificate revocation incident is to renew the certificate. This typically involves generating a new certificate signing request (CSR), submitting it to a certificate authority (CA), and then installing the new certificate on the affected instance.
```shell
#!/bin/bash

# Use certbot to renew certificate
certbot renew --cert-name "$CERTIFICATE_NAME"
```