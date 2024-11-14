variable "hostname" {
  type        = string
  description = "Device hostname"
}

variable "tls" {
  type    = bool
  default = true
}
variable "username" {
  type    = string
  default = "admin"
}

variable "password" {
  type    = string
  default = "Cisco1234!"
}

variable "host" {
  type = string
}

variable "router_id" {
  type = string
}

variable "interfaces" {
  type = map(object({
    description  = string
    ipv4_address = string
    ipv4_mask    = string
    enabled      = bool
  }))
}

variable "isis" {
  type = object({
    process_id = string
    is_type    = string
    net_id     = string
    segment_routing_interface = string
    segment_routing_sid_index = string
    interfaces = map(object({
      interface_name = string
      circuit_type   = string
      p2p           = bool
    }))
  })
}

variable "bgp" {
  type = object({
    as_number = string
    neighbors = map(object({
      neighbor_address = string
      remote_as       = string
      description     = string
      update_source   = optional(string)
    }))
    vrfs = optional(map(object({
      vrf_name         = string
      neighbor_address = string
      remote_as       = string
      description     = string
    })))
  })
}

variable "vrfs" {
  type = map(object({
    vrf_name    = string
    description = string
    vpn_id      = string
    rd_two_byte_as_as_number = string
    rd_two_byte_as_index     = number
    import_route_targets = list(object({
      as_number = string
      index     = number
    }))
    export_route_targets = list(object({
      as_number = string
      index     = number
    }))
  }))
  default = {}
}