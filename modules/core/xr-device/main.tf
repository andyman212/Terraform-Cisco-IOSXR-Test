terraform {
  required_providers {
    iosxr = {
      source = "CiscoDevNet/iosxr"
    }
  }
}

provider "iosxr" {
  host     = var.host
  username = var.username
  password = var.password
  tls      = var.tls
}

module "xr_base_config" {
  source = "../xr_base"
  
  hostname = var.hostname
}

module "xr_interfaces" {
  source = "../interfaces"
  
  interfaces = var.interfaces
}

module "xr_routing_isis" {
  source = "../routing/isis"
  
  process_id = var.isis.process_id
  segment_routing_interface = var.isis.segment_routing_interface
  segment_routing_sid_index = var.isis.segment_routing_sid_index
  is_type    = var.isis.is_type
  net_id     = var.isis.net_id
  router_id  = var.router_id
  interfaces = var.isis.interfaces

}

module "xr_routing_bgp" {
  source = "../routing/bgp"

  as_number     = var.bgp.as_number
  bgp_router_id = var.router_id
  neighbors     = var.bgp.neighbors
  vrfs         = var.bgp.vrfs

}

module "xr_routing_mpls" {
  source = "../routing/mpls"
  
  router_id = var.router_id

}

module "xr_routing_vrf" {
  source = "../routing/vrf"

  bgp_dependency = module.xr_routing_bgp
  vrfs          = var.vrfs

}