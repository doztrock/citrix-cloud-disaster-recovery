include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../terraform-modules/security-group"
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../vpc"
}

inputs = {

  name        = "ssm"
  description = "Allows access to AWS SSM"

  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = dependency.vpc.outputs.vpc_cidr_block
      rule        = "https-443-tcp"
    }
  ]

}
