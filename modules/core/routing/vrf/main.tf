terraform {
  required_providers {
    iosxr = {
      source = "ciscodevnet/iosxr"
    }
  }
}

resource "iosxr_vrf" "example" {
  depends_on = [var.bgp_dependency]

  for_each = var.vrfs

  vrf_name                                        = each.value.vrf_name
  description                                     = each.value.description
  vpn_id                                          = each.value.vpn_id
  address_family_ipv4_unicast                     = true
  rd_two_byte_as_as_number                        = each.value.rd_two_byte_as_as_number
  rd_two_byte_as_index                            = each.value.rd_two_byte_as_index
  address_family_ipv4_unicast_import_route_target_two_byte_as_format = [
    for importrt in each.value.import_route_targets :
    {
      as_number = importrt.as_number
      index     = importrt.index
      stitching = true
    }
  ]
  address_family_ipv4_unicast_export_route_target_two_byte_as_format = [
    for exportrt in each.value.export_route_targets :
    {
      as_number = exportrt.as_number
      index     = exportrt.index
      stitching = true
    }
  ]
}