variable "ACCEPTER_AWS_ACCESS_KEY_ID" {
  type     = string
  nullable = false
}

variable "ACCEPTER_AWS_SECRET_ACCESS_KEY" {
  type     = string
  nullable = false
}

variable "ACCEPTER_AWS_REGION" {
  type     = string
  nullable = false
}

variable "REQUESTER_AWS_ACCESS_KEY_ID" {
  type     = string
  nullable = false
}

variable "REQUESTER_AWS_SECRET_ACCESS_KEY" {
  type     = string
  nullable = false
}

variable "REQUESTER_AWS_REGION" {
  type     = string
  nullable = false
}

variable "accepter_peer_region" {
  type     = string
  nullable = false
}

variable "accepter_peer_vpc_id" {
  type     = string
  nullable = false
}

variable "accepter_private_route_table_ids" {
  type     = list(string)
  nullable = false
}

variable "accepter_public_route_table_ids" {
  type     = list(string)
  nullable = false
}

variable "accepter_vpc_cidr_block" {
  type     = string
  nullable = false
}

variable "requester_private_route_table_ids" {
  type     = list(string)
  nullable = false
}

variable "requester_public_route_table_ids" {
  type     = list(string)
  nullable = false
}

variable "requester_vpc_cidr_block" {
  type     = string
  nullable = false
}

variable "requester_vpc_id" {
  type     = string
  nullable = false
}
