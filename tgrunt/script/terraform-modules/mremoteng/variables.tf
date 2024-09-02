variable "ADMINISTRATOR_USERNAME" {
  type     = string
  nullable = false
}

variable "ADMINISTRATOR_PASSWORD" {
  type     = string
  nullable = false
}

variable "CC_DR_ADDRESS" {
  type     = string
  nullable = false
}

variable "CC_MAIN_ADDRESS" {
  type     = string
  nullable = false
}

variable "DC_DR_ADDRESS" {
  type     = string
  nullable = false
}

variable "DC_MAIN_ADDRESS" {
  type     = string
  nullable = false
}

variable "DOMAIN_NAME" {
  type     = string
  nullable = false
}

variable "DOMAIN_NETBIOS_NAME" {
  type     = string
  nullable = false
}

variable "HOSTNAMES" {
  type     = map(string)
  nullable = false
}

variable "PATH" {
  type     = string
  nullable = false
}
