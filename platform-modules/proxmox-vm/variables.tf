variable "vms" {
  description = <<-EOD
    Map of VM definitions. Each key is an identifier for a VM and each value is an object with:
      - vmid: Numeric VM ID.
      - hostname: The desired VM name.
      - node (optional): Proxmox node to deploy the VM on. If not specified, default_node is used.
      - template: The Cloud‑Init–ready template to clone (name or ID).
      - cores: Number of CPU cores.
      - memory: Memory in MB.
      - disk_size: Root disk size (e.g., "32G").
      - static_ip: Static IP address with CIDR (e.g., "10.0.30.226/24").
      - gateway: Gateway IP address (e.g., "10.0.30.1").
      - ciuser: Cloud‑Init user name (e.g., "packer" or "blueq").
      - cipassword: Password for the Cloud‑Init user (if needed for password auth).
      - ssh_keys: A string containing one or more SSH public keys.
  EOD
  type = map(object({
    vmid       = number
    hostname   = string
    node       = optional(string)
    template   = string
    cores      = number
    memory     = number
    disk_size  = string
    static_ip  = string
    gateway    = string
    ciuser     = string
    cipassword = string
    ssh_keys   = string
    tags       = optional(string)
    nw_bridge  = string
    nw_model   = string
    storage    = string
    vlan_tag   = number
    ci_storage = string
  }))
}

variable "default_vm_node" {
  type        = string
  description = "Default node for VM creation"
}

variable "default_vm_storage" {
  type    = string
  default = "local"
}

variable "default_vm_ci_storage"{
  type    = string
  default = "truenas-backup"
}

variable "default_vm_nw_model" {
  type    = string
  default = "virtio"
}

variable "default_vm_nw_bridge" {
  type    = string
  default = "vmbr0"
}

variable "default_vm_vlan_tag" {
  type    = number
  default = 2
}

variable "default_ssh_private_key" {
  type    = string
  default = "~/.ssh/id_rsa"
}
