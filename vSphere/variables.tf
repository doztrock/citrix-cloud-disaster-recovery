variable "VSPHERE_SERVER" {
  type     = string
  nullable = false
}

variable "VSPHERE_USER" {
  type     = string
  nullable = false
}

variable "VSPHERE_PASSWORD" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "HOSTS" {
  type = map(object({
    hostname = string
    username = string
    password = string
  }))
  nullable = false
}

variable "DEFAULT_PASSWORD" {
  type      = string
  nullable  = false
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
