output "netbox_vm" {
  description = "The VM details retrieved from NetBox"
  value       = local.netbox_vm
}

output "proxmox_vm" {
  description = "The VM details created on Proxmox"
  value       = proxmox_vm_qemu.vm
}