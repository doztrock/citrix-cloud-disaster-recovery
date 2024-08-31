variable "DR_AWS_ACCESS_KEY_ID" {
  type     = string
  nullable = false
}

variable "DR_AWS_SECRET_ACCESS_KEY" {
  type      = string
  nullable  = false
  sensitive = true
}
