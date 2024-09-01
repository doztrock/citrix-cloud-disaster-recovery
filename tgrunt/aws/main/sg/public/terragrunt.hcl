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

  name        = "public"
  description = "Allows inbound and outbound traffic to and from the internet"

  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_rules = ["all-all"]
  egress_rules  = ["all-all"]

}
