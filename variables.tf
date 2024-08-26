variable "CITRIX_CUSTOMER_ID" {
  type     = string
  nullable = false
}

variable "CITRIX_CLIENT_ID" {
  type     = string
  nullable = false
}

variable "CITRIX_CLIENT_SECRET" {
  type      = string
  nullable  = false
  sensitive = true
}

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

variable "ARE_CC_READY" {
  type    = bool
  default = false
}

variable "IS_GI_READY" {
  type    = bool
  default = false
}
