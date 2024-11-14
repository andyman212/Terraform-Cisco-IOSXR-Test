variable "process_id" {
  description = "ISIS process ID"
  type        = string
}

variable "is_type" {
  description = "ISIS type"
  type        = string
}

variable "net_id" {
  description = "ISIS net ID"
  type        = string
}

variable "router_id" {
  description = "ISIS router ID"
  type        = string
}

variable "segment_routing_interface" {
  description = "ISIS segment routing interface"
  type        = string
}

variable "interfaces" {
  description = "ISIS interfaces"
  type        = map(object({
    interface_name = string
    circuit_type   = string
    p2p            = bool
  }))
}

variable "segment_routing_sid_index" {
  description = "ISIS segment routing SID index"
  type        = string
}
