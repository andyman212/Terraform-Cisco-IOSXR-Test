variable "interfaces" {
  description = "Map of interface configurations"
  type = map(object({
    description  = string
    ipv4_address = string
    ipv4_mask    = string
    enabled      = bool
  }))
  default = {}
}