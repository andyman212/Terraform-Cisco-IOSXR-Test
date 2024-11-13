provider "iosxr" {
  alias    = "lab-eve-xr9kv-02"
  username = "admin"
  password = "Cisco1234!"
  host     = "192.168.50.50"
  tls      = false
}

module "xr_base_config_lab_eve_xr9kv_02" {
  source = "../../../modules/core/xr_base"
  
  hostname = "lab-eve-xr9kv-02"

  providers = {
    iosxr = iosxr.lab-eve-xr9kv-02
  }
}

module "xr_interfaces_lab_eve_xr9kv_02" {
  source = "../../../modules/core/interfaces"
  
  interfaces = {
    "Loopback0" = {
      description = "Global Loopback"
      ipv4_address = "10.10.10.2"
      ipv4_mask    = "255.255.255.255"
      enabled      = true
    },
    "GigabitEthernet0/0/0/1" = {
      description = "Connection to LAB-EVE-XR9KV-01"
      ipv4_address = "10.255.255.2"
      ipv4_mask    = "255.255.255.252"
      enabled      = true
    }
  }

  providers = {
    iosxr = iosxr.lab-eve-xr9kv-02
  }
}

module "xr_routing_isis_lab_eve_xr9kv_02" {
  source = "../../../modules/core/routing/isis"
  
  process_id = "CORE"
  is_type    = "level-1"
  router_id  = "10.10.10.2"
  net_id     = "49.0001.2222.2222.0002.00"
  interfaces = {
    "GigabitEthernet0/0/0/1" = {
      interface_name = "GigabitEthernet0/0/0/1"
      circuit_type   = "level-1"
      p2p            = true
    },
    "Loopback0" = {
      interface_name = "Loopback0"
      circuit_type   = "level-1"
      p2p            = true
    }
  }

  providers = {
    iosxr = iosxr.lab-eve-xr9kv-02
  }
}

module "xr_routing_bgp_lab_eve_xr9kv_02" {
  source = "../../../modules/core/routing/bgp"

  as_number = "65000"
  bgp_router_id = "10.10.10.2"
  neighbors = {
    "10.10.10.1" = {
      neighbor_address = "10.10.10.1"
      remote_as        = "65000"
      description      = "LAB-EVE-XR9KV-01"
      update_source    = "Loopback0"
    }
  }

  providers = {
    iosxr = iosxr.lab-eve-xr9kv-02
  }
}

module "xr_routing_mpls_lab_eve_xr9kv_02" {
  source = "../../../modules/core/routing/mpls"
  
  router_id = "10.10.10.2"

  providers = {
    iosxr = iosxr.lab-eve-xr9kv-02
  }
}