include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../terraform-modules/ec2-instance"
}

locals {
  common      = read_terragrunt_config("${get_terragrunt_dir()}/../../../terragrunt.hcl")
  DOMAIN_NAME = local.common.inputs.DOMAIN_NAME
}

inputs = {
  name = "DC01.${local.DOMAIN_NAME}"
}