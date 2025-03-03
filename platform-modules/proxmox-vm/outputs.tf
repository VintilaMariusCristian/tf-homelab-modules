
output "vm_ips" {
  description = "Mapping of VM names to their Cloud-Init ipconfig0 values."
  value       = { for k, v in proxmox_vm_qemu.vm : k => v.ipconfig0 }
}