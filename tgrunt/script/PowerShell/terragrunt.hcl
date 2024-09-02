include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../terraform-modules/powershell"
}

dependency "ec2-main-dc" {
  config_path = "${get_terragrunt_dir()}/../../aws/main/ec2/domain-controller"
  mock_outputs = {
    private_ip = "10.0.0.0"
  }
}

dependency "ec2-dr-dc" {
  config_path = "${get_terragrunt_dir()}/../../aws/dr/ec2/domain-controller"
  mock_outputs = {
    private_ip = "10.0.0.0"
  }
}

locals {

  common = read_terragrunt_config("${get_terragrunt_dir()}/../../terragrunt.hcl")

  DOMAIN_NAME         = local.common.inputs.DOMAIN_NAME
  DOMAIN_NETBIOS_NAME = local.common.inputs.DOMAIN_NETBIOS_NAME
  HOSTNAMES           = local.common.inputs.HOSTNAMES

}

inputs = {

  PATH      = get_terragrunt_dir()
  HOSTNAMES = local.HOSTNAMES

  DC_DR_ADDRESS   = dependency.ec2-dr-dc.outputs.private_ip
  DC_MAIN_ADDRESS = dependency.ec2-main-dc.outputs.private_ip

  DOMAIN_NAME         = local.DOMAIN_NAME
  DOMAIN_NETBIOS_NAME = local.DOMAIN_NETBIOS_NAME

}
