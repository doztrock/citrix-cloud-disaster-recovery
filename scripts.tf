resource "random_password" "dsrm" {
  length           = 16
  override_special = "!@#$%^&*()-_=+[]{}|;:,.<>?/~"
}

resource "local_file" "deploy-main-dc" {
  filename = "${path.module}/script/0-deploy-main-dc.ps1"
  content = templatefile("${path.module}/script/template/0-deploy-main-dc.tpl", {
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME
    DSRM_PASSWORD       = random_password.dsrm.result
  })
}

resource "local_file" "join-main-cc" {
  filename = "${path.module}/script/2-join-main-cc.ps1"
  content = templatefile("${path.module}/script/template/2-join-main-cc.tpl", {
    SERVER_ADDRESS      = module.ec2-main-dc.private_ip
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = "Administrator",
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "join-dr-cc" {
  filename = "${path.module}/script/3-join-dr-cc.ps1"
  content = templatefile("${path.module}/script/template/3-join-dr-cc.tpl", {
    SERVER_ADDRESS      = module.ec2-main-dc.private_ip
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = "Administrator",
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "join-main-gi" {
  filename = "${path.module}/script/4-join-main-gi.ps1"
  content = templatefile("${path.module}/script/template/4-join-main-gi.tpl", {
    SERVER_ADDRESS      = module.ec2-main-dc.private_ip
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = "Administrator",
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}
