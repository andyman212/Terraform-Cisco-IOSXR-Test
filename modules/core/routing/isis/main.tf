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
  set_overload_bit_levels = [
    {
      level_id                                             = 1
      on_startup_advertise_as_overloaded                   = true
      on_startup_advertise_as_overloaded_time_to_advertise = 10
      on_startup_wait_for_bgp                              = false
      advertise_external                                   = true
      advertise_interlevel                                 = true
    }
  ]
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
  mpls_ldp_auto_config    = true
  metric_style_narrow     = false
  metric_style_wide       = true
  metric_style_transition = false
  microloop_avoidance_segment_routing = true
  metric_style_levels = [
    {
      level_id   = 1
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
      level_id = 1
      ti_lfa   = true
    }
  ]
}
resource "iosxr_segment_routing" "example" {
  global_block_lower_bound = 16000
  global_block_upper_bound = 29999
  local_block_lower_bound  = 15000
  local_block_upper_bound  = 15999
}