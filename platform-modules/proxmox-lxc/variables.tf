###############################################################################
# modules/proxmox_lxc/variables.tf
###############################################################################

variable "lxcs" {
  type = map(object({
    vmid         = number
    hostname     = string
    node         = optional(string)
    ostemplate   = string
    password     = optional(string)
    ssh_key      = optional(string)
    unprivileged = bool
    nesting      = bool
    cores        = number
    memory       = number
    swap         = number
    disk_size    = string
    lxc_storage  = string
    ip           = string
    gw           = string
    firewall     = optional(bool, false)
    tags         = optional(string) 
    nw_bridge    = string
    nw_interface = string

  }))
  default = {}
}

variable "default_lxc_node" {
  type    = string
  default = "pve"
}

variable "default_lxc_storage" {
  type    = string
  default = "local"
}

variable "default_lxc_disk_size" {
  type    = string
  default = "8G"
}

variable "default_lxc_password" {
  type      = string
  sensitive = true
  default   = "default-pass"
}

variable "default_ssh_public_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "start_containers" {
  type    = bool
  default = true
}

variable "default_lxc_nw_interface" {
  type    = string
  default = "eth0"
}

variable "default_lxc_nw_bridge" {
  type    = string
  default = "vmbr0"

}