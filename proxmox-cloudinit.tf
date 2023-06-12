resource "proxmox_vm_qemu" "cloudinit" {
  count = var.image_type == "cloudinit" ? 1 : 0
  depends_on = [
    null_resource.set_netbox_vm_status_staged
  ]
  name        = var.name
  bios        = var.bios
  balloon     = local.balloon
  onboot      = var.onboot
  desc        = var.comments
  target_node = var.target_node
  clone       = var.template
  agent       = 1
  memory      = var.memory
  cores       = var.cores
  boot        = "order=${var.boot_order}"
  pool        = "critical"
  qemu_os     = var.qemu_os
  cpu         = var.cpu
  hastate     = var.ha_state == "" ? null : var.ha_state
  hagroup     = var.ha_state == "" ? null : var.ha_group
  scsihw      = var.scsihw

  # CloudInit
  os_type      = "cloud-init"
  ciuser       = "packer"
  cipassword   = "packer"
  ipconfig0    = "gw=172.29.14.1,ip=${local.ip_address2}"
  nameserver   = "172.29.14.7,172.29.14.8"
  searchdomain = var.dns_domain

  disk {
    size    = "${var.disk_size}G"
    storage = var.storage
    type    = var.disk_type
    discard = "on"
  }

  network {
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
    tag       = -1
    mtu       = 0
  }

  lifecycle {
    ignore_changes = [args, clone, hagroup, target_node, full_clone]
  }
}
