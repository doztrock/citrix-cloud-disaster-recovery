include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../terraform-modules/security-group"
}

dependency "vpc-dr" {
  config_path = "${get_terragrunt_dir()}/../../vpc"
  mock_outputs = {
    vpc_id         = "vpc-01234567890abcdef"
    vpc_cidr_block = "10.0.0.0/8"
  }
}

dependency "vpc-main" {
  config_path = "${get_terragrunt_dir()}/../../../main/vpc"
  mock_outputs = {
    vpc_cidr_block = "10.0.0.0/8"
  }
}

inputs = {

  name        = "private"
  description = "Allows access to the resources on both networks"

  vpc_id = dependency.vpc-dr.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = dependency.vpc-dr.outputs.vpc_cidr_block
      rule        = "all-all"
    },
    {
      cidr_blocks = dependency.vpc-main.outputs.vpc_cidr_block
      rule        = "all-all"
    }
  ]

  egress_rules = ["all-all"]

}
