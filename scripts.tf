resource "random_password" "dsrm" {
  length           = 16
  override_special = "!@#$%^&*()-_=+[]{}|;:,.<>?/~"
}

resource "local_file" "deploy-main-dc" {
  filename = "${path.module}/script/0-deploy-main-dc.ps1"
  content = templatefile("${path.module}/script/template/deploy-main-dc.tpl", {
    HOSTNAME            = "DCPD01.${var.DOMAIN_NAME}",
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME
    DSRM_PASSWORD       = random_password.dsrm.result
  })
}

resource "local_file" "join-dr-dc" {
  filename = "${path.module}/script/1-join-dr-dc.ps1"
  content = templatefile("${path.module}/script/template/join.tpl", {
    HOSTNAME            = "DCPD51.${var.DOMAIN_NAME}",
    SERVER_ADDRESS      = module.ec2-main-dc.private_ip,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = "Administrator",
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "deploy-dr-dc" {
  filename = "${path.module}/script/2-deploy-dr-dc.ps1"
  content = templatefile("${path.module}/script/template/deploy-dr-dc.tpl", {
    HOSTNAME            = "DCPD51.${var.DOMAIN_NAME}",
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = "Administrator",
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD,
    DSRM_PASSWORD       = random_password.dsrm.result
  })
}

resource "local_file" "create-sites" {
  filename = "${path.module}/script/3-create-sites.ps1"
  content = templatefile("${path.module}/script/template/create-sites.tpl", {
    HOSTNAME    = "DCPD01.${var.DOMAIN_NAME}",
    MAIN_SUBNET = module.vpc-main.vpc_cidr_block,
    DR_SUBNET   = module.vpc-dr.vpc_cidr_block
  })
}

resource "local_file" "join-main-cc" {
  filename = "${path.module}/script/4-join-main-cc.ps1"
  content = templatefile("${path.module}/script/template/join.tpl", {
    HOSTNAME            = "CCPD01.${var.DOMAIN_NAME}",
    SERVER_ADDRESS      = module.ec2-main-dc.private_ip,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = "Administrator",
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "join-dr-cc" {
  filename = "${path.module}/script/5-join-dr-cc.ps1"
  content = templatefile("${path.module}/script/template/join.tpl", {
    HOSTNAME            = "CCPD51.${var.DOMAIN_NAME}",
    SERVER_ADDRESS      = module.ec2-main-dc.private_ip,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = "Administrator",
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "join-main-gi" {
  filename = "${path.module}/script/6-join-main-gi.ps1"
  content = templatefile("${path.module}/script/template/join.tpl", {
    HOSTNAME            = "GIPD01.${var.DOMAIN_NAME}",
    SERVER_ADDRESS      = module.ec2-main-dc.private_ip,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = "Administrator",
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}
