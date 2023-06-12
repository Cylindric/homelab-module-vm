##################
# COMMON SETTINGS
##################
variable "name" {
  description = "The machine name for the new VM"
  type        = string
}

variable "role_id" {
  type    = number
  default = 0
}

variable "comments" {
  type    = string
  default = "Created by TF"
}

variable "interface_name" {
  type    = string
  default = "eth0"
}

variable "gateway" {
  type    = string
  default = "172.29.14.1"
}

variable "nameserver" {
  type    = string
  default = "172.29.14.7"
}

variable "dns_domain" {
  type    = string
  default = "home.cylindric.net"
}

variable "storage" {
  type    = string
  default = "shared-vms"
}

variable "cname" {
  type    = string
  default = null
}

##################
# NETBOX SETTINGS
##################

variable "netbox_cluster" {
  type    = string
  default = "proxmox"
}

###################
# PROX VM SETTINGS
###################
variable "template" {
  description = "The name of the template to clone"
  type        = string
  default     = "ubuntu-22.04-1"
}

variable "template_type" {
  description = "The type of template, i.e. cloudinit, clone"
  default     = "cloudinit"
  validation {
    condition     = contains(["cloudinit", "clone"], var.template_type)
    error_message = "Image Type must be a valid type (cloudinit or clone)."
  }
}

variable "memory" {
  description = "How much memory (Mb) to allocate to the VM"
  type        = number
  default     = 1024
  validation {
    condition     = var.memory > 0 && var.memory <= 16384
    error_message = "Memory must be between 0 and 16384 Mb."
  }
}

variable "cores" {
  description = "How many CPU cores to allocate to the VM"
  type        = number
  default     = 2
  validation {
    condition     = var.cores > 0 && var.cores <= 4
    error_message = "Cores must be between 1 and 4."
  }
}

variable "target_node" {
  description = "The name of the Proxmox node to place the VM on"
  type        = string
  default     = "prox01"
  validation {
    condition     = contains(["prox01", "prox02", "prox03"], var.target_node)
    error_message = "Target Node must be a valid Proxmox node in the cluster."
  }
}

variable "bios" {
  type    = string
  default = "seabios"
}

variable "cpu" {
  type    = string
  default = "host"
}

variable "balloon" {
  description = "Memory Balloon amount, must be <= Memory"
  type        = number
  default     = 0
}

variable "qemu_os" {
  type    = string
  default = "l26"
}

variable "onboot" {
  type    = bool
  default = false
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "boot_order" {
  type    = string
  default = "scsi0"
}

variable "scsihw" {
  type    = string
  default = "virtio-scsi-pci"
}

variable "disk_type" {
  type    = string
  default = "scsi"
}

variable "ha_state" {
  description = "The desired HA state of the VM"
  type        = string
  default     = "started"
  validation {
    condition     = contains(["", "started", "stopped", "ignored", "disabled"], var.ha_state)
    error_message = "HA State must be a valid HA state, or blank to not use."
  }
}

variable "ha_group" {
  description = "The desired HA group of the VM"
  type        = string
  default     = "any_node"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "pool" {
  type    = string
  default = "critical"
}