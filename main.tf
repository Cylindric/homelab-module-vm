moved {
  from = proxmox_vm_qemu.vm
  to   = proxmox_vm_qemu.clone[0]
}
moved {
  from = null_resource.set_static_ip
  to   = null_resource.set_static_ip[0]
}

#################
# NETBOX LOOKUPS
#################
data "netbox_cluster" "netbox_cluster" {
  name = var.netbox_cluster
}

data "netbox_virtual_machines" "netbox_vms" {
  name_regex = "^${var.name}$"
  filter {
    name  = "cluster_id"
    value = data.netbox_cluster.netbox_cluster.id
  }
}

#########
# LOCALS
#########

locals {
  netbox_vm    = data.netbox_virtual_machines.netbox_vms.vms[0]
  netbox_vm_id = local.netbox_vm.vm_id
  num_certs    = (var.generate_certificate ? 1 : 0)
  num_cnames   = (var.cname == null ? 0 : 1)
  fqdn         = "${var.name}.${var.dns_domain}"
  balloon      = (var.balloon > var.memory ? var.memory : var.balloon)

  ip_address2 = local.netbox_vm.primary_ip4
  ip_address  = split("/", local.ip_address2)[0]
}
