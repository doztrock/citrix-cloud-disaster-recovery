data "vsphere_virtual_machine" "main-template" {
  provider      = vsphere.main
  datacenter_id = vsphere_datacenter.main.moid
  name          = "WindowsServer2019"
}

data "vsphere_resource_pool" "main" {
  provider      = vsphere.main
  datacenter_id = vsphere_datacenter.main.moid
  name          = "Resources"
}

resource "vsphere_virtual_machine" "main-dc" {

  provider = vsphere.main

  name = var.HOSTNAMES.MAIN_DC

  resource_pool_id = data.vsphere_resource_pool.main.id
  datastore_id     = data.vsphere_datastore.main.id

  num_cpus = data.vsphere_virtual_machine.main-template.num_cpus
  memory   = data.vsphere_virtual_machine.main-template.memory

  firmware  = data.vsphere_virtual_machine.main-template.firmware
  guest_id  = data.vsphere_virtual_machine.main-template.guest_id
  scsi_type = data.vsphere_virtual_machine.main-template.scsi_type

  disk {
    label            = data.vsphere_virtual_machine.main-template.disks.0.label
    size             = data.vsphere_virtual_machine.main-template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.main-template.disks.0.thin_provisioned
  }

  network_interface {
    network_id   = data.vsphere_network.main.id
    adapter_type = data.vsphere_virtual_machine.main-template.network_interface_types[0]
  }

  clone {

    template_uuid = data.vsphere_virtual_machine.main-template.id

    customize {

      windows_options {
        computer_name  = var.HOSTNAMES.MAIN_DC
        workgroup      = "WORKGROUP"
        admin_password = var.DEFAULT_PASSWORD
        time_zone      = 35
      }

      network_interface {}

    }

  }

}

resource "vsphere_virtual_machine" "main-cc" {

  provider = vsphere.main

  name = var.HOSTNAMES.MAIN_CC

  resource_pool_id = data.vsphere_resource_pool.main.id
  datastore_id     = data.vsphere_datastore.main.id

  num_cpus = data.vsphere_virtual_machine.main-template.num_cpus
  memory   = data.vsphere_virtual_machine.main-template.memory

  firmware  = data.vsphere_virtual_machine.main-template.firmware
  guest_id  = data.vsphere_virtual_machine.main-template.guest_id
  scsi_type = data.vsphere_virtual_machine.main-template.scsi_type

  disk {
    label            = data.vsphere_virtual_machine.main-template.disks.0.label
    size             = data.vsphere_virtual_machine.main-template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.main-template.disks.0.thin_provisioned
  }

  network_interface {
    network_id   = data.vsphere_network.main.id
    adapter_type = data.vsphere_virtual_machine.main-template.network_interface_types[0]
  }

  clone {

    template_uuid = data.vsphere_virtual_machine.main-template.id

    customize {

      windows_options {
        computer_name  = var.HOSTNAMES.MAIN_CC
        workgroup      = "WORKGROUP"
        admin_password = var.DEFAULT_PASSWORD
        time_zone      = 35
      }

      network_interface {}

    }

  }

}
