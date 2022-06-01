# Root Certificate Authority
resource "tls_private_key" "ca_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

# Root Public Certificate
resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem   = tls_private_key.ca_key.private_key_pem
  is_ca_certificate = true

  subject {
    common_name  = "Consul Agent CA"
    organization = "HashiCorp Inc."
  }

  validity_period_hours = 8760

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature"
  ]
}

# Consul Server Certs
resource "tls_private_key" "consul_server_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

## Consul Server Cert
resource "tls_cert_request" "consul_server_cert" {
  private_key_pem = tls_private_key.consul_server_key.private_key_pem

  subject {
    common_name  = "server.${var.consul_dc1_name}.consul"
    organization = "HashiCorp Inc."
  }

  dns_names = [
    "server.dc1.consul",
    "localhost"
  ]

  # ip_addresses = var.consul_server_private_ips
  ip_addresses = local.server_private_ips
}

## Consul Server Signed Public Certificate
resource "tls_locally_signed_cert" "consul_server_signed_cert" {
  cert_request_pem = tls_cert_request.consul_server_cert.cert_request_pem

  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  allowed_uses = [
    "digital_signature",
    "key_encipherment"
  ]

  validity_period_hours = 8760
}