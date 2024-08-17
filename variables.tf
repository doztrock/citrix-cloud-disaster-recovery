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
