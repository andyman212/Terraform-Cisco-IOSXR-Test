terraform {
  required_providers {
    iosxr = {
      source = "CiscoDevNet/iosxr"
    }
  }
}

resource "iosxr_l2vpn_xconnect_group_p2p" "example" {
  group_name        = var.group_name
  p2p_xconnect_name = var.p2p_xconnect_name
  description       = var.description
  interfaces = [
    {
      interface_name = var.interface_name + var.vlan_id
    }
  ]
  neighbor_evpn_evi_segment_routing_services = [
    {
      vpn_id                       = var.vpn_id
      service_id                   = var.service_id
    }
  ]
}