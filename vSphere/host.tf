data "vsphere_host_thumbprint" "main" {
  provider = vsphere.main
  address  = var.VSPHERE_SERVER
  insecure = true
}

data "vsphere_host_thumbprint" "dr" {
  provider = vsphere.dr
  address  = var.VSPHERE_SERVER
  insecure = true
}

resource "vsphere_host" "main" {
  provider   = vsphere.main
  datacenter = vsphere_datacenter.main.id
  hostname   = var.HOSTS.main.hostname
  username   = var.HOSTS.main.username
  password   = var.HOSTS.main.password
  thumbprint = data.vsphere_host_thumbprint.main.id
}

resource "vsphere_host" "dr" {
  provider   = vsphere.dr
  datacenter = vsphere_datacenter.dr.id
  hostname   = var.HOSTS.dr.hostname
  username   = var.HOSTS.dr.username
  password   = var.HOSTS.dr.password
  thumbprint = data.vsphere_host_thumbprint.dr.id
}
