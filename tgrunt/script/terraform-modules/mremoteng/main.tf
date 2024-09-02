resource "local_file" "confCons" {
  filename = "${var.PATH}/confCons.xml"
  content = templatefile("${path.module}/template/confCons.xml.tpl", {

    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    USERNAME            = var.ADMINISTRATOR_USERNAME,

    MAIN_DC           = var.HOSTNAMES.MAIN_DC,
    MAIN_DC_PUBLIC_IP = var.DC_MAIN_ADDRESS,

    MAIN_CC           = var.HOSTNAMES.MAIN_CC,
    MAIN_CC_PUBLIC_IP = var.CC_MAIN_ADDRESS,

    DR_DC           = var.HOSTNAMES.DR_DC,
    DR_DC_PUBLIC_IP = var.DC_DR_ADDRESS,

    DR_CC           = var.HOSTNAMES.DR_CC,
    DR_CC_PUBLIC_IP = var.CC_DR_ADDRESS

  })
}
