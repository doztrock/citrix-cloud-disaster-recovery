include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../terraform-modules/ec2-instance"
}

dependency "instance-profile" {
  config_path = "${get_terragrunt_dir()}/../../iam/instance-profile"
  mock_outputs = {
    name = "mock-instance-profile-name"
  }
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../vpc"
  mock_outputs = {
    private_subnets = ["subnet-01234567890abcdef"]
  }
}

dependency "sg-private" {
  config_path = "${get_terragrunt_dir()}/../../sg/private"
  mock_outputs = {
    security_group_id = "sg-0abcdef1234567890"
  }
}

locals {

  common = read_terragrunt_config("${get_terragrunt_dir()}/../../../../terragrunt.hcl")

  DOMAIN_NAME = local.common.inputs.DOMAIN_NAME
  HOSTNAMES   = local.common.inputs.HOSTNAMES

}

inputs = {

  hostname    = local.HOSTNAMES.MAIN_GI
  domain_name = local.DOMAIN_NAME

  instance_type        = "t3.medium"
  iam_instance_profile = dependency.instance-profile.outputs.name

  subnet_id = dependency.vpc.outputs.private_subnets[0]
  vpc_security_group_ids = [
    dependency.sg-private.outputs.security_group_id
  ]

}
