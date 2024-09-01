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

variable "ADMINISTRATOR_USERNAME" {
  type     = string
  nullable = false
}

variable "ADMINISTRATOR_PASSWORD" {
  type     = string
  nullable = false
}

variable "domain_name" {
  type     = string
  nullable = false
}

variable "hostname" {
  type     = string
  nullable = false
}

variable "iam_instance_profile" {
  type     = string
  nullable = false
}

variable "instance_type" {
  type     = string
  nullable = false
}

variable "subnet_id" {
  type     = string
  nullable = false
}

variable "vpc_security_group_ids" {
  type     = list(string)
  nullable = false
}
