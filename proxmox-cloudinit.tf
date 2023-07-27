data "vault_kv_secret_v2" "ansible" {
  mount = "kv"
  name  = "services/ansible"
}

resource "proxmox_vm_qemu" "cloudinit" {
  count = var.template_type == "cloudinit" ? 1 : 0
  depends_on = [
    null_resource.set_netbox_vm_status_staged
  ]
  name             = var.name
  bios             = var.bios
  balloon          = local.balloon
  onboot           = var.onboot
  desc             = var.comments
  target_node      = var.target_node
  clone            = var.template
  agent            = 1
  memory           = var.memory
  cores            = var.cores
  pool             = var.pool
  qemu_os          = var.qemu_os
  cpu              = var.cpu
  hastate          = var.ha_state == "" ? null : var.ha_state
  hagroup          = var.ha_state == "" ? null : var.ha_group
  scsihw           = var.scsihw
  automatic_reboot = var.automatic_reboot

  # CloudInit
  os_type      = "cloud-init"
  ipconfig0    = "ip=${local.ip_address},gw=${var.gateway}"
  nameserver   = var.nameserver
  searchdomain = var.dns_domain
  ciuser       = data.vault_kv_secret_v2.ansible.data.ssh_user
  sshkeys      = data.vault_kv_secret_v2.ansible.data.public_key

  disk {
    size    = "${var.disk_size}G"
    storage = var.storage
    type    = var.disk_type
    discard = "on"
    aio     = var.disk_aio
  }

  network {
    bridge    = var.bridge
    firewall  = false
    link_down = false
    model     = "virtio"
    tag       = -1
    mtu       = 0
  }

  lifecycle {
    ignore_changes = [
      target_node, # if the VM changes host, don't force it back
    ]
  }
}
