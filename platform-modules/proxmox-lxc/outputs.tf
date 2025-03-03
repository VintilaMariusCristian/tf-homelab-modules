###############################################################################
# modules/proxmox_lxc/outputs.tf
###############################################################################

output "lxc_outputs" {
  description = "Map of LXC container info"
  value = {
    for key, ctr in proxmox_lxc.containers : key => {
      vmid     = ctr.vmid
      hostname = ctr.hostname
      ip       = ctr.network[0].ip
      id       = ctr.id
    }
  }
}