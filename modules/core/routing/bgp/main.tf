terraform {
  required_providers {
    iosxr = {
      source = "CiscoDevNet/iosxr"
    }
  }
}

resource "iosxr_router_bgp" "example" {
  as_number                                  = var.as_number
  bgp_router_id                              = var.bgp_router_id

  neighbors = [
    for neighbor in var.neighbors : {
      neighbor_address                    = neighbor.neighbor_address
      remote_as                           = neighbor.remote_as
      description                         = neighbor.description
      update_source                       = neighbor.update_source
    }
    ]
}

resource "iosxr_router_bgp_address_family" "ipv4" {
  as_number                               = var.as_number
  af_name                                 = "ipv4-unicast"
}

resource "iosxr_router_bgp_address_family" "vpnv4" {
  as_number                               = var.as_number
  af_name                                 = "vpnv4-unicast"
}

resource "iosxr_router_bgp_neighbor_address_family" "ipv4" {
  for_each = { for idx, neighbor in var.neighbors : idx => neighbor }
  
  as_number        = var.as_number
  neighbor_address = each.value.neighbor_address
  af_name          = "ipv4-unicast"
}

resource "iosxr_router_bgp_neighbor_address_family" "vpnv4" {
  for_each = { for idx, neighbor in var.neighbors : idx => neighbor }
  
  as_number        = var.as_number
  neighbor_address = each.value.neighbor_address
  af_name          = "vpnv4-unicast"
}

resource "iosxr_router_bgp_vrf_address_family" "vrf" {
  for_each = { for idx, vrf in var.vrfs : idx => vrf }

  as_number                               = var.as_number
  vrf_name                                = each.value.vrf_name
  af_name                                 = "ipv4-unicast"
  redistribute_static                     = true
}

resource "iosxr_router_bgp_vrf" "vrf" {
  for_each = var.vrfs

  as_number                     = var.as_number
  vrf_name                      = each.value.vrf_name
  rd_auto                       = true
  neighbors = [
    {
      neighbor_address                = each.value.neighbor_address
      remote_as                       = each.value.remote_as
      description                     = each.value.description
    }
  ]
}