include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../terraform-modules/security-group"
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../vpc"
  mock_outputs = {
    vpc_id = "vpc-01234567890abcdef"
  }
}

inputs = {

  name        = "ping"
  description = "Allows inbound ICMP"

  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = "0.0.0.0/0"
      rule        = "all-icmp"
    }
  ]

}
