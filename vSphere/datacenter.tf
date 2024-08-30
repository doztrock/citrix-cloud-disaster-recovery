resource "vsphere_datacenter" "main" {
  provider = vsphere.main
  name     = "Main"
}

resource "vsphere_datacenter" "dr" {
  provider = vsphere.dr
  name     = "DR"
}
