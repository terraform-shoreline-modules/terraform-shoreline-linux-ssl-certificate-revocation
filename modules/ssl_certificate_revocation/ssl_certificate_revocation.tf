resource "shoreline_notebook" "ssl_certificate_revocation" {
  name       = "ssl_certificate_revocation"
  data       = file("${path.module}/data/ssl_certificate_revocation.json")
  depends_on = [shoreline_action.invoke_check_cert_expiry,shoreline_action.invoke_check_certificate,shoreline_action.invoke_renew_certificate]
}

resource "shoreline_file" "check_cert_expiry" {
  name             = "check_cert_expiry"
  input_file       = "${path.module}/data/check_cert_expiry.sh"
  md5              = filemd5("${path.module}/data/check_cert_expiry.sh")
  description      = "The SSL certificate for the instance expired and was not renewed in a timely manner."
  destination_path = "/agent/scripts/check_cert_expiry.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_certificate" {
  name             = "check_certificate"
  input_file       = "${path.module}/data/check_certificate.sh"
  md5              = filemd5("${path.module}/data/check_certificate.sh")
  description      = "The SSL certificate was issued by an untrusted or compromised certificate authority."
  destination_path = "/agent/scripts/check_certificate.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "renew_certificate" {
  name             = "renew_certificate"
  input_file       = "${path.module}/data/renew_certificate.sh"
  md5              = filemd5("${path.module}/data/renew_certificate.sh")
  description      = "Renew the SSL certificate: The first step to resolving an SSL certificate revocation incident is to renew the certificate. This typically involves generating a new certificate signing request (CSR), submitting it to a certificate authority (CA), and then installing the new certificate on the affected instance."
  destination_path = "/agent/scripts/renew_certificate.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_cert_expiry" {
  name        = "invoke_check_cert_expiry"
  description = "The SSL certificate for the instance expired and was not renewed in a timely manner."
  command     = "`chmod +x /agent/scripts/check_cert_expiry.sh && /agent/scripts/check_cert_expiry.sh`"
  params      = ["INSTANCE","CERTIFICATE_FILE"]
  file_deps   = ["check_cert_expiry"]
  enabled     = true
  depends_on  = [shoreline_file.check_cert_expiry]
}

resource "shoreline_action" "invoke_check_certificate" {
  name        = "invoke_check_certificate"
  description = "The SSL certificate was issued by an untrusted or compromised certificate authority."
  command     = "`chmod +x /agent/scripts/check_certificate.sh && /agent/scripts/check_certificate.sh`"
  params      = ["NAME_OF_SSL_CERTIFICATE_AUTHORITY","INSTANCE","CERTIFICATE_FILE","PATH_TO_CA_BUNDLE_FILE"]
  file_deps   = ["check_certificate"]
  enabled     = true
  depends_on  = [shoreline_file.check_certificate]
}

resource "shoreline_action" "invoke_renew_certificate" {
  name        = "invoke_renew_certificate"
  description = "Renew the SSL certificate: The first step to resolving an SSL certificate revocation incident is to renew the certificate. This typically involves generating a new certificate signing request (CSR), submitting it to a certificate authority (CA), and then installing the new certificate on the affected instance."
  command     = "`chmod +x /agent/scripts/renew_certificate.sh && /agent/scripts/renew_certificate.sh`"
  params      = ["CERTIFICATE_NAME"]
  file_deps   = ["renew_certificate"]
  enabled     = true
  depends_on  = [shoreline_file.renew_certificate]
}

