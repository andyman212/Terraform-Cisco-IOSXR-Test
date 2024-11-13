terraform {
  required_providers {
    iosxr = {
      source  = "CiscoDevNet/iosxr"
      version = "0.5.2"
    }
  }
}

provider "iosxr" {
  username = "admin"
  password = "Cisco1234!"
  tls      = false
  devices  = [
    {
      name = "lab-eve-xrv9kv-01"
      host = "192.168.50.91"
    }
  ]
}