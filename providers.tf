terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/dns/latest
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.2.0"
    }

    # https://registry.terraform.io/providers/e-breuninger/netbox/latest
    netbox = {
      source  = "e-breuninger/netbox"
      version = ">= 3.0.13"
    }

    # https://registry.terraform.io/providers/Telmate/proxmox/latest
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">= 2.9.13"
    }

    # https://registry.terraform.io/providers/hashicorp/vault/latest
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.5.0"
    }
  }
}
