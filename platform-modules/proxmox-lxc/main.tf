###############################################################################
# modules/proxmox_lxc/main.tf
###############################################################################

terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
  }
}

resource "proxmox_lxc" "containers" {
  for_each = var.lxcs

  vmid        = each.value.vmid
  hostname    = each.value.hostname
  target_node = coalesce(each.value.node, var.default_lxc_node)

  ostemplate = each.value.ostemplate
  start      = var.start_containers
  tags = lookup(each.value, "tags", "")
  password = coalesce(
    lookup(each.value, "password", null),
    var.default_lxc_password
  )

  ssh_public_keys = file(
    coalesce(
      lookup(each.value, "ssh_key", null),
      var.default_ssh_public_key
    )
  )

  cores     = each.value.cores
  memory    = each.value.memory
  swap      = each.value.swap

  rootfs {
    storage = coalesce(each.value.lxc_storage, var.default_lxc_storage)
    size    = coalesce(each.value.disk_size, var.default_lxc_disk_size)
  }

  unprivileged = each.value.unprivileged
  features {
    nesting = each.value.nesting
  }

  network {
    name     = coalesce(each.value.nw_interface, var.default_lxc_nw_interface)
    bridge   = coalesce(each.value.nw_bridge, var.default_lxc_nw_bridge)
    ip       = each.value.ip
    gw       = each.value.gw
    firewall = coalesce(each.value.firewall, false)
  }

  lifecycle {
    ignore_changes = all
  }
}