resource "random_password" "dsrm" {
  length           = 16
  override_special = "!@#$%^&*()-_=+[]{}|;:,.<>?/~"
}

resource "local_file" "deploy-main-dc" {
  filename = "${var.PATH}/0-deploy-main-dc.ps1"
  content = templatefile("${path.module}/template/deploy-main-dc.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.MAIN_DC}.${var.DOMAIN_NAME}",
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    DSRM_PASSWORD       = random_password.dsrm.result
  })
}


resource "local_file" "join-dr-dc" {
  filename = "${var.PATH}/1-join-dr-dc.ps1"
  content = templatefile("${path.module}/template/join.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.DR_DC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1    = var.DC_MAIN_ADDRESS,
    SERVER_ADDRESS_2    = "",
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "deploy-dr-dc" {
  filename = "${var.PATH}/2-deploy-dr-dc.ps1"
  content = templatefile("${path.module}/template/deploy-dr-dc.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.DR_DC}.${var.DOMAIN_NAME}",
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD,
    DSRM_PASSWORD       = random_password.dsrm.result
  })
}

resource "local_file" "set-dns-dc-main" {
  filename = "${var.PATH}/3-set-dns-dc-main.ps1"
  content = templatefile("${path.module}/template/set-dns-dc.tpl", {
    HOSTNAME         = "${var.HOSTNAMES.MAIN_DC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1 = var.DC_MAIN_ADDRESS,
    SERVER_ADDRESS_2 = var.DC_DR_ADDRESS,
    DOMAIN_NAME      = var.DOMAIN_NAME
  })
}

resource "local_file" "set-dns-dc-dr" {
  filename = "${var.PATH}/4-set-dns-dc-dr.ps1"
  content = templatefile("${path.module}/template/set-dns-dc.tpl", {
    HOSTNAME         = "${var.HOSTNAMES.DR_DC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1 = var.DC_DR_ADDRESS,
    SERVER_ADDRESS_2 = var.DC_MAIN_ADDRESS,
    DOMAIN_NAME      = var.DOMAIN_NAME
  })
}

resource "local_file" "create-sites" {
  filename = "${var.PATH}/5-set-replication-time.ps1"
  content = templatefile("${path.module}/template/set-replication-time.tpl", {
    HOSTNAME = "${var.HOSTNAMES.MAIN_DC}.${var.DOMAIN_NAME}"
  })
}

resource "local_file" "join-main-cc" {
  filename = "${var.PATH}/6-join-main-cc.ps1"
  content = templatefile("${path.module}/template/join.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.MAIN_CC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1    = var.DC_MAIN_ADDRESS,
    SERVER_ADDRESS_2    = var.DC_DR_ADDRESS,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "join-dr-cc" {
  filename = "${var.PATH}/7-join-dr-cc.ps1"
  content = templatefile("${path.module}/template/join.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.DR_CC}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1    = var.DC_DR_ADDRESS,
    SERVER_ADDRESS_2    = var.DC_MAIN_ADDRESS,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}

resource "local_file" "join-main-gi" {
  filename = "${var.PATH}/8-join-main-gi.ps1"
  content = templatefile("${path.module}/template/join.tpl", {
    HOSTNAME            = "${var.HOSTNAMES.MAIN_GI}.${var.DOMAIN_NAME}",
    SERVER_ADDRESS_1    = var.DC_MAIN_ADDRESS,
    SERVER_ADDRESS_2    = var.DC_DR_ADDRESS,
    DOMAIN_NAME         = var.DOMAIN_NAME,
    DOMAIN_NETBIOS_NAME = var.DOMAIN_NETBIOS_NAME,
    JOIN_USERNAME       = var.ADMINISTRATOR_USERNAME,
    JOIN_PASSWORD       = var.ADMINISTRATOR_PASSWORD
  })
}
