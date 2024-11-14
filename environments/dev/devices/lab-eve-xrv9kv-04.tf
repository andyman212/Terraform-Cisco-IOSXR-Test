module "lab-eve-xrv9kv-04" {
  source = "../../../modules/core/xr-device"

  tls          = true
  host         = "192.168.50.234"
  router_id    = "10.10.10.4"

  hostname     = "lab-eve-xrv9kv-04"

  interfaces = {
    "Loopback0" = {
      description  = "Global Loopback"
      ipv4_address = "10.10.10.4"
      ipv4_mask    = "255.255.255.255"
      enabled      = true
    },
    "GigabitEthernet0/0/0/0" = {
      description  = "Connection to LAB-EVE-XR9KV-02"
      ipv4_address = "10.255.255.10"
      ipv4_mask    = "255.255.255.252"
      enabled      = true
    },
    "GigabitEthernet0/0/0/1" = {
      description  = "Connection to LAB-EVE-XR9KV-03"
      ipv4_address = "10.255.255.14"
      ipv4_mask    = "255.255.255.252"
      enabled      = true
    }
  }

  isis = {
    process_id = "CORE"
    is_type    = "level-2-only"
    segment_routing_interface = "Loopback0"
    segment_routing_sid_index = "104"
    net_id     = "49.0001.2222.2222.0004.00"
    interfaces = {
      "GigabitEthernet0/0/0/0" = {
        interface_name = "GigabitEthernet0/0/0/0"
        circuit_type   = "level-2-only"
        p2p           = true
      },
      "GigabitEthernet0/0/0/1" = {
        interface_name = "GigabitEthernet0/0/0/1"
        circuit_type   = "level-2-only"
        p2p           = true
      },
      "Loopback0" = {
        interface_name = "Loopback0"
        circuit_type   = "level-2-only"
        p2p           = true
      }
    }
  }

  bgp = {
    as_number = "65000"
    neighbors = {
      "10.10.10.1" = {
        neighbor_address = "10.10.10.1"
        remote_as       = "65000"
        description     = "LAB-EVE-XR9KV-01"
        update_source   = "Loopback0"
      },
      "10.10.10.2" = {
        neighbor_address = "10.10.10.2"
        remote_as       = "65000"
        description     = "LAB-EVE-XR9KV-02"
        update_source   = "Loopback0"
      },
      "10.10.10.3" = {
        neighbor_address = "10.10.10.3"
        remote_as       = "65000"
        description     = "LAB-EVE-XR9KV-03"
        update_source   = "Loopback0"
      }
    }
    vrfs = {
      "INTERNET" = {
        vrf_name         = "INTERNET"
        neighbor_address = "212.1.1.4"
        remote_as       = "65002"
        description     = "ISP Router"
      }
    }
  }

  vrfs = {
    "INTERNET" = {
      vrf_name    = "INTERNET"
      description = "Internet VRF"
      vpn_id      = "100:1"
      rd_two_byte_as_as_number = "1"
      rd_two_byte_as_index     = 1
      import_route_targets = [
        {
          as_number = "1"
          index     = 1
        },
        {
          as_number = "2"
          index     = 2
        }
      ]
      export_route_targets = [
        {
          as_number = "1"
          index     = 1
        }
      ]
    }
  }
}