terraform {
  required_providers {
    iosxr = {
      source = "CiscoDevNet/iosxr"
    }
  }
}

resource "iosxr_router_isis" "example" {
  process_id                                                            = var.process_id
  is_type                                                               = var.is_type
  log_adjacency_changes             = true
  nets = [
    {
      net_id = var.net_id
    }
  ]
  interfaces = [
    for interface in var.interfaces : {
      interface_name          = interface.interface_name
      circuit_type            = interface.circuit_type
      priority                = 10
      point_to_point          = interface.p2p
      passive                 = false
      suppressed              = false
      shutdown                = false
    }
  ]
}

resource "iosxr_router_isis_address_family" "example" {
  process_id              = var.process_id
  af_name                 = "ipv4"
  saf_name                = "unicast"
  mpls_ldp_auto_config    = false
  metric_style_narrow     = false
  metric_style_wide       = true
  metric_style_transition = false
  microloop_avoidance_segment_routing = true
  metric_style_levels = [
    {
      level_id   = 2
      narrow     = false
      wide       = true
      transition = false
    }
  ]
  router_id_ip_address  = var.router_id
}

resource "iosxr_router_isis_interface_address_family" "example" {
  for_each = var.interfaces
  process_id     = var.process_id
  interface_name = each.value.interface_name
  af_name        = "ipv4"
  saf_name       = "unicast"

  fast_reroute_per_prefix        = can(regex("^Loopback", each.value.interface_name)) ? false : true
  fast_reroute_per_prefix_ti_lfa = can(regex("^Loopback", each.value.interface_name)) ? false : true
  fast_reroute_per_prefix_levels = can(regex("^Loopback", each.value.interface_name)) ? [] : [
    {
      level_id = 2
      ti_lfa   = true
    }
  ]
}

resource "iosxr_gnmi" "segment_routing" {
  path = "Cisco-IOS-XR-um-router-isis-cfg:/router/isis/processes/process[process-id=${var.process_id}]/address-families/address-family[af-name=ipv4][saf-name=unicast]/segment-routing/mpls"
  attributes = {
    sr-prefer = true
  }
}

resource "iosxr_gnmi" "segment_routing_interface" {
  path = "Cisco-IOS-XR-um-router-isis-cfg:/router/isis/processes/process[process-id=${var.process_id}]/interfaces/interface[interface-name=${var.segment_routing_interface}]/address-families/address-family[af-name=ipv4][saf-name=unicast]/prefix-sid/sid/index/"
  attributes = {
    sid-index = var.segment_routing_sid_index
  }
}