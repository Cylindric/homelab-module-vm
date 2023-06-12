resource "null_resource" "set_netbox_vm_status_staged" {
  triggers = {
    vm_id = local.netbox_vm_id
  }

  provisioner "local-exec" {
    command = <<EOT
      curl \
        -X PATCH \
        -H "Authorization: Token $NETBOX_API_TOKEN" \
        -H "Content-Type: application/json" \
        $NETBOX_SERVER_URL/api/virtualization/virtual-machines/${self.triggers.vm_id}/ \
        --data '{"status": "staged"}'
    EOT
  }
}


resource "null_resource" "set_netbox_vm_status" {
  depends_on = [
    proxmox_vm_qemu.vm
  ]

  triggers = {
    vm_id = local.netbox_vm_id
  }

  provisioner "local-exec" {
    command = <<EOT
      curl \
        -X PATCH \
        -H "Authorization: Token $NETBOX_API_TOKEN" \
        -H "Content-Type: application/json" \
        $NETBOX_SERVER_URL/api/virtualization/virtual-machines/${self.triggers.vm_id}/ \
        --data '{"status": "active"}'
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      curl \
        -X PATCH \
        -H "Authorization: Token $NETBOX_API_TOKEN" \
        -H "Content-Type: application/json" \
        $NETBOX_SERVER_URL/api/virtualization/virtual-machines/${self.triggers.vm_id}/ \
        --data '{"status": "decommissioning"}'
    EOT
  }
}
