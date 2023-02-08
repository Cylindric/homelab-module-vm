# Publishing
```bash
git tag -a "v1.0.0" -m "Version 1.0.0"
git push origin --tags
```
# Upgrading

```bash
MODULE_NAME=vm-vault01 #
PROX_NODE=prox02 #
PROX_ID=105 #
terragrunt init --upgrade #
terragrunt state rm "module.$MODULE_NAME.proxmox_vm_qemu.vm[0]" #
terragrunt import "module.$MODULE_NAME.proxmox_vm_qemu.vm" /$PROX_NODE/vm/$PROX_ID #
terragrunt state rm "module.$MODULE_NAME.netbox_interface.interface[0]" #
terragrunt state rm "module.$MODULE_NAME.netbox_available_ip_address.auto-ip[0]" #
terragrunt state rm "module.$MODULE_NAME.netbox_primary_ip.auto-ip[0]" #
terragrunt state rm "module.$MODULE_NAME.netbox_virtual_machine.vm[0]" #
terragrunt state rm "module.$MODULE_NAME.vault_generic_secret.root_password[0]" #
```
