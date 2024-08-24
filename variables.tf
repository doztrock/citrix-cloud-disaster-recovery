variable "DOMAIN_NAME" {
  type    = string
  default = "homelab.corp"
}

variable "DOMAIN_NETBIOS_NAME" {
  type    = string
  default = "HOMELAB"
}

variable "ADMINISTRATOR_USERNAME" {
  type    = string
  default = "Administrator"
}

variable "ADMINISTRATOR_PASSWORD" {
  type      = string
  sensitive = true
}

variable "HOSTNAMES" {
  type = map(string)
  default = {
    "MAIN_DC" = "DCPD01",
    "MAIN_CC" = "CCPD01",
    "MAIN_GI" = "GIPD01",
    "DR_DC"   = "DCPD51",
    "DR_CC"   = "CCPD51"
  }
}

variable "INGRESS_WITH_CIDR_BLOCKS" {
  type = list(object({
    cidr_blocks = string
    rule        = string
  }))
  default = []
}
