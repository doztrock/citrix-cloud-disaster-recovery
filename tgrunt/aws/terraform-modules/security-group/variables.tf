variable "AWS_ACCESS_KEY_ID" {
  type     = string
  nullable = false
}

variable "AWS_SECRET_ACCESS_KEY" {
  type     = string
  nullable = false
}

variable "AWS_REGION" {
  type     = string
  nullable = false
}

variable "description" {
  type     = string
  nullable = false
}

variable "egress_rules" {
  type    = list(string)
  default = []
}

variable "egress_with_cidr_blocks" {
  type    = list(map(string))
  default = []
}

variable "ingress_rules" {
  type    = list(string)
  default = []
}

variable "ingress_with_cidr_blocks" {
  type    = list(map(string))
  default = []
}

variable "name" {
  type     = string
  nullable = false
}

variable "vpc_id" {
  type     = string
  nullable = false
}
