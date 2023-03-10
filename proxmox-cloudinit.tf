data "vault_kv_secret_v2" "ansible" {
  mount = "kv"
  name  = "services/ansible"
}

resource "proxmox_vm_qemu" "cloudinit" {
  count = var.template_type == "cloudinit" ? 1 : 0
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
  pool        = "critical"
  qemu_os     = var.qemu_os
  cpu         = var.cpu
  hastate     = var.ha_state == "" ? null : var.ha_state
  hagroup     = var.ha_state == "" ? null : var.ha_group
  scsihw      = var.scsihw

  # CloudInit
  os_type          = "cloud-init"
  ipconfig0        = "ip=${local.ip_address2},gw=172.29.14.1"
  nameserver       = "172.29.14.7"
  searchdomain     = var.dns_domain
  automatic_reboot = true
  ciuser           = data.vault_kv_secret_v2.ansible.data.ssh_user
  sshkeys          = data.vault_kv_secret_v2.ansible.data.public_key

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
    ignore_changes = [
      target_node, # if the VM changes host, don't force it back
    ]
  }
}
