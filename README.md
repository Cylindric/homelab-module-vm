# HomeLab VM Module

This module provisions the necessary services related to a HomeLab VM as follows:

1. Looks up the NetBox Cluster where the VM will be placed (needed for finding the VM)
1. Looks up the metadata about the VM from NetBox (used for CMDB status update)
1. Marks the VM as "staged" prior to build
1. Clones the VM template in Proxmox to a new VM
1. Marks the VM as "active" once clone is complete
1. Creates a DNS A record for the VM in AD-DNS
1. Creates a DNS CNAME record for the VM in AD-DNS (optional)
1. Generates a new TLS Certificate for the VM (optional)
