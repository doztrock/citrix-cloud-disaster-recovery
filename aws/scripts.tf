resource "random_password" "dsrm" {
  length           = 16
  override_special = "!@#$%^&*()-_=+[]{}|;:,.<>?/~"
}

resource "local_file" "deploy-main-dc" {
  filename = "${path.module}/script/0-deploy-main-dc.ps1"
  content = templatefile("${path.module}/script/template/deploy-main-dc.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.MAIN_DC}.${var.DOMAIN_NAME}",
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME
    DSRM_PASSWORD       = random_password.dsrm.result
  })
}

resource "local_file" "join-dr-dc" {
  filename = "${path.module}/script/1-join-dr-dc.ps1"
  content = templatefile("${path.module}/script/template/join.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.DR_DC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1    = module.ec2-main-dc.private_ip,
    SERVER_ADDRESS_2    = "",
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "deploy-dr-dc" {
  filename = "${path.module}/script/2-deploy-dr-dc.ps1"
  content = templatefile("${path.module}/script/template/deploy-dr-dc.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.DR_DC}.${var.DOMAIN_NAME}",
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD,
    DSRM_PASSWORD       = random_password.dsrm.result
  })
}

resource "local_file" "set-dns-dc-main" {
  filename = "${path.module}/script/3-set-dns-dc-main.ps1"
  content = templatefile("${path.module}/script/template/set-dns-dc.tpl", {
    HOSTNAME         = "${var.HOSTNAMES.MAIN_DC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1 = module.ec2-main-dc.private_ip,
    SERVER_ADDRESS_2 = module.ec2-dr-dc.private_ip,
    DOMAIN_NAME      = var.DOMAIN_NAME
  })
}

resource "local_file" "set-dns-dc-dr" {
  filename = "${path.module}/script/4-set-dns-dc-dr.ps1"
  content = templatefile("${path.module}/script/template/set-dns-dc.tpl", {
    HOSTNAME         = "${var.HOSTNAMES.DR_DC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1 = module.ec2-dr-dc.private_ip,
    SERVER_ADDRESS_2 = module.ec2-main-dc.private_ip,
    DOMAIN_NAME      = var.DOMAIN_NAME
  })
}

resource "local_file" "create-sites" {
  filename = "${path.module}/script/5-set-replication-time.ps1"
  content = templatefile("${path.module}/script/template/set-replication-time.tpl", {
    HOSTNAME = "${var.HOSTNAMES.MAIN_DC}.${var.DOMAIN_NAME}"
  })
}

resource "local_file" "join-main-cc" {
  filename = "${path.module}/script/6-join-main-cc.ps1"
  content = templatefile("${path.module}/script/template/join.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.MAIN_CC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1    = module.ec2-main-dc.private_ip,
    SERVER_ADDRESS_2    = module.ec2-dr-dc.private_ip,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "join-dr-cc" {
  filename = "${path.module}/script/7-join-dr-cc.ps1"
  content = templatefile("${path.module}/script/template/join.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.DR_CC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1    = module.ec2-dr-dc.private_ip,
    SERVER_ADDRESS_2    = module.ec2-main-dc.private_ip,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "join-main-gi" {
  filename = "${path.module}/script/8-join-main-gi.ps1"
  content = templatefile("${path.module}/script/template/join.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.MAIN_GI}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1    = module.ec2-main-dc.private_ip,
    SERVER_ADDRESS_2    = module.ec2-dr-dc.private_ip,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "download-main-cc" {
  filename = "${path.module}/script/9-download-main-cc.ps1"
  content = templatefile("${path.module}/script/template/download-cloud-connector.tpl", {
    HOSTNAME    = "${var.HOSTNAMES.MAIN_CC}.${var.DOMAIN_NAME}",
    CUSTOMER_ID = var.CITRIX_CUSTOMER_ID
  })
}

resource "local_file" "download-dr-cc" {
  filename = "${path.module}/script/10-download-dr-cc.ps1"
  content = templatefile("${path.module}/script/template/download-cloud-connector.tpl", {
    HOSTNAME    = "${var.HOSTNAMES.DR_CC}.${var.DOMAIN_NAME}",
    CUSTOMER_ID = var.CITRIX_CUSTOMER_ID
  })
}

resource "local_file" "confCons" {
  filename = "${path.module}/mRemoteNG/confCons.xml"
  content = templatefile("${path.module}/mRemoteNG/template/confCons.xml.tpl", {
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    USERNAME            = var.ADMINISTRATOR_USERNAME,
    MAIN_DC             = var.HOSTNAMES.MAIN_DC,
    MAIN_DC_PUBLIC_IP   = module.ec2-main-dc.public_ip,
    MAIN_CC             = var.HOSTNAMES.MAIN_CC,
    MAIN_CC_PUBLIC_IP   = module.ec2-main-cc.public_ip,
    DR_DC               = var.HOSTNAMES.DR_DC,
    DR_DC_PUBLIC_IP     = module.ec2-dr-dc.public_ip,
    DR_CC               = var.HOSTNAMES.DR_CC,
    DR_CC_PUBLIC_IP     = module.ec2-dr-cc.public_ip
  })
}
