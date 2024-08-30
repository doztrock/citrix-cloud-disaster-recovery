terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.8.3"
      configuration_aliases = [
        vsphere.main, vsphere.dr
      ]
    }
  }
}

provider "vsphere" {
  alias                = "main"
  vsphere_server       = var.VSPHERE_SERVER
  user                 = var.VSPHERE_USER
  password             = var.VSPHERE_PASSWORD
  allow_unverified_ssl = true
}

provider "vsphere" {
  alias                = "dr"
  vsphere_server       = var.VSPHERE_SERVER
  user                 = var.VSPHERE_USER
  password             = var.VSPHERE_PASSWORD
  allow_unverified_ssl = true
}
