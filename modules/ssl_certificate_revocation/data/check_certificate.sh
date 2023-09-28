

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