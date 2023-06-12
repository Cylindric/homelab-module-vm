# Register an A-Record for this VM
resource "dns_a_record_set" "auto-record" {
  zone      = "${var.dns_domain}."
  name      = var.name
  addresses = [local.ip_address]
  ttl       = 300
}

# VMs can have an optional CNAME record
resource "dns_cname_record" "cname" {
  count = local.num_cnames
  zone  = "${var.dns_domain}."
  name  = var.cname
  cname = "${dns_a_record_set.auto-record.name}.${var.dns_domain}."
  ttl   = 3600
}
