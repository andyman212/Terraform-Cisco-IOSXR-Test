terraform {
  required_providers {
    iosxr = {
      source = "ciscodevnet/iosxr"
    }
  }
}

resource "iosxr_mpls_ldp" "example" {
  router_id = var.router_id
}