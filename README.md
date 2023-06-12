# Publishing
```bash
git tag -a "v1.0.0" -m "Version 1.0.0"
```
# Upgrading

```bash
terragrunt state rm 'module.vm-jenkins.netbox_interface.interface[0]'
terragrunt state rm 'module.vm-jenkins.netbox_available_ip_address.auto-ip[0]'
terragrunt state rm 'module.vm-jenkins.netbox_primary_ip.auto-ip[0]'
terragrunt state rm 'module.vm-jenkins.netbox_virtual_machine.vm[0]'
```