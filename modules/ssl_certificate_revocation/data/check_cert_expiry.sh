

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