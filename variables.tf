variable "AWS_ACCESS_KEY_ID" {
  type     = string
  nullable = false
}

variable "AWS_SECRET_ACCESS_KEY" {
  type     = string
  nullable = false
}

variable "INGRESS_WITH_CIDR_BLOCKS" {
  type = list(object({
    cidr_blocks = string
    rule        = string
  }))
  default = []
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

variable "DOMAIN_NAME" {
  type    = string
  default = "homelab.corp"
}

variable "DOMAIN_NETBIOS_NAME" {
  type    = string
  default = "HOMELAB"
}

variable "ADMINISTRATOR_PASSWORD" {
  type      = string
  sensitive = true
}
