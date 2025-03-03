# --------------------------------------------------------------------------
# Example: A Cloud-Init–enabled VM using a Packer-built template
# --------------------------------------------------------------------------

terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      # If you need a specific version, pin it here
      # version = "2.9.14"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  for_each = var.vms

  # Basic VM info
  vmid        = each.value.vmid
  name        = each.value.hostname
  target_node = coalesce(each.value.node, var.default_vm_node)
  tags = lookup(each.value, "tags", "")
  # Clone from your Packer-built, Cloud-Init–ready Proxmox template
  clone      = each.value.template
  full_clone = true

  # Resources
  cores  = each.value.cores
  memory = each.value.memory
  agent  = 1  # optional, if you're installing QEMU guest agent

  # Tell Proxmox to use “virtio-scsi-pci” or whichever SCSI controller you prefer
  scsihw = "virtio-scsi-pci"

  # 1) Main OS Disk
  # 2) CloudInit Disk
  disks {
    scsi {
      # Primary OS Disk
      scsi0 {
        disk {
          storage = coalesce(each.value.storage, var.default_vm_storage)
          size    = each.value.disk_size
        }
      }

      # CloudInit disk
      # This “cloudinit” block is what automatically creates
      # the recognized Cloud-Init drive (instead of a custom ISO).
      scsi1 {
        cloudinit {
          # Where to store the cloud-init disk
          storage = coalesce(each.value.ci_storage, var.default_vm_ci_storage)
        }
      }
    }
  }

  # Network interface
  network {
    id     = 0
    model  = coalesce(each.value.nw_model, var.default_vm_nw_model)
    bridge = coalesce(each.value.nw_bridge, var.default_vm_nw_bridge)
    tag    = coalesce(each.value.vlan_tag, var.default_vm_vlan_tag)
  }

  # ------------------------------------------------------------------------
  # Cloud-Init user/password/SSH config
  # ------------------------------------------------------------------------
  ciuser     = each.value.ciuser
  cipassword = each.value.cipassword

  # Insert your static IP/gateway
  ipconfig0 = "ip=${each.value.static_ip},gw=${each.value.gateway}"

  # Provide public SSH keys to be placed in authorized_keys
  sshkeys = file(each.value.ssh_keys)

  # If you need to do provisioning from Terraform with remote-exec, supply a private key
  ssh_private_key = file(
    coalesce(
      lookup(each.value, "ssh_key", null),
       var.default_ssh_private_key
    )
  )

  # Optional: ignore changes so TF doesn't try to re-deploy on minor differences
  lifecycle {
    ignore_changes = all
  }
}