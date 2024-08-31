data "vsphere_datastore" "main" {
  provider      = vsphere.main
  datacenter_id = vsphere_datacenter.main.moid
  name          = "datastore1"
}

data "vsphere_datastore" "dr" {
  provider      = vsphere.dr
  datacenter_id = vsphere_datacenter.dr.moid
  name          = "datastore1"
}
