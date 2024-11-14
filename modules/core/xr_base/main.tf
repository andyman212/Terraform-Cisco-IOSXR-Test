terraform {
  required_providers {
    iosxr = {
      source = "CiscoDevNet/iosxr"
    }
  }
}

resource "iosxr_hostname" "device_hostname" {
  system_network_name = var.hostname
}

resource "iosxr_banner" "example" {
  banner_type = "login"
  line        = "Authorized Access Only, this device is for authorized users only and is protected by law."
}

resource "iosxr_ssh" "example" {
  server_dscp          = 48
  server_logging       = true
  server_rate_limit    = 60
  server_session_limit = 10
  server_v2            = true
}