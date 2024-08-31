data "vsphere_network" "main" {
  provider      = vsphere.main
  datacenter_id = vsphere_datacenter.main.moid
  name          = "VM Network"
}

data "vsphere_network" "dr" {
  provider      = vsphere.dr
  datacenter_id = vsphere_datacenter.dr.moid
  name          = "VM Network"
}
