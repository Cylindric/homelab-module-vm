resource "vault_pki_secret_backend_cert" "certificate" {
  count                 = local.num_certs
  backend               = "pki-int-ca"
  name                  = "server-cert"
  auto_renew            = true
  min_seconds_remaining = 604800 # 604800=7 days

  common_name = local.fqdn
  ip_sans     = [local.ip_address]
}

resource "local_file" "certificate-private-file" {
  count    = local.num_certs
  content  = vault_pki_secret_backend_cert.certificate[count.index].private_key
  filename = "output/server-certs/${var.name}-key.pem"
}

resource "local_file" "certificate-file" {
  count    = local.num_certs
  content  = vault_pki_secret_backend_cert.certificate[count.index].certificate
  filename = "output/server-certs/${var.name}.pem"
}