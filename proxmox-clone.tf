resource "proxmox_vm_qemu" "clone" {
  count = var.template_type == "clone" ? 1 : 0
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
  pool        = var.pool
  qemu_os     = var.qemu_os
  cpu         = var.cpu
  hastate     = var.ha_state == "" ? null : var.ha_state
  hagroup     = var.ha_state == "" ? null : var.ha_group
  scsihw      = var.scsihw

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "${var.disk_size}"
          storage = var.storage
          discard = true
        }
      }
    }
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
    ignore_changes = [args, clone, hagroup, target_node, full_clone]
  }
}

resource "null_resource" "set_static_ip" {
  count = var.template_type == "clone" ? 1 : 0

  connection {
    type     = "ssh"
    user     = "packer"
    password = "packer"
    host     = proxmox_vm_qemu.clone[count.index].ssh_host
  }

  provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "echo \"network:\" | sudo tee /etc/netplan/00-installer-config.yaml",
      "echo \"  ethernets:\" | sudo tee -a /etc/netplan/00-installer-config.yaml",
      "echo \"    ${var.interface_name}:\" | sudo tee -a /etc/netplan/00-installer-config.yaml",
      "echo \"      dhcp4: no\" | sudo tee -a /etc/netplan/00-installer-config.yaml",
      "echo \"      addresses: [${local.ip_address}]\" | sudo tee -a /etc/netplan/00-installer-config.yaml",
      "echo \"      gateway4: ${var.gateway}\" | sudo tee -a /etc/netplan/00-installer-config.yaml",
      "echo \"      nameservers:\" | sudo tee -a /etc/netplan/00-installer-config.yaml",
      "echo \"        addresses: [${var.nameserver}]\" | sudo tee -a /etc/netplan/00-installer-config.yaml",
      "sudo apt install -y at",
      "echo \"sleep 5s && sudo netplan apply\" | at now"
    ]
  }
}
