terraform {
  required_providers {
    iosxr = {
      source = "CiscoDevNet/iosxr"
    }
  }
}

resource "iosxr_interface" "interface" {
  for_each = var.interfaces

  interface_name = each.key
  description    = each.value.description
  ipv4_address   = each.value.ipv4_address
  ipv4_netmask   = each.value.ipv4_mask
  shutdown       = !each.value.enabled
}