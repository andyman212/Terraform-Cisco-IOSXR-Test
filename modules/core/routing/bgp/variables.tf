variable "neighbors" {
  description = "BGP neighbors"
  type        = map(object({
    neighbor_address = string
    remote_as        = string
    description      = string
    update_source    = string
  }))
}

variable "as_number" {
  description = "BGP AS number"
  type        = string
}

variable "bgp_router_id" {
  description = "BGP router ID"
  type        = string
}

variable "vrfs" {
  description = "VRFs"
  type        = map(object({
    vrf_name         = string
    neighbor_address = string
    remote_as        = string
    description      = string
  }))
  default     = {}  # Makes the variable explicitly optional
}
