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
  balloon      = (var.balloon > var.memory ? var.memory : var.balloon)
  ip_address   = local.netbox_vm.primary_ip4
}
