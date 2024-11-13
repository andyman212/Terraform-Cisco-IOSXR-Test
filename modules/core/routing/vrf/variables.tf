variable "vrfs" {
  description = "VRFs"
  type        = map(object({
    vrf_name                                        = string
    description                                     = string
    vpn_id                                          = string
    rd_two_byte_as_as_number                        = string
    rd_two_byte_as_index                            = number
    import_route_targets                            = list(object({
      as_number = string
      index     = number
    }))
    export_route_targets                            = list(object({
      as_number = string
      index     = number
    }))
  }))
}

variable "bgp_dependency" {
  description = "Resource dependency for BGP configuration"
  default     = null
}