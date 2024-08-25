include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../terraform-modules/vpc"
}

locals {
  cidr = "10.20.0.0/16"
  azs  = ["us-west-2a", "us-west-2b"]
}

inputs = {

  name = "dr"

  cidr = local.cidr
  azs  = local.azs

  public_subnets  = [cidrsubnet(local.cidr, 8, 1), cidrsubnet(local.cidr, 8, 2)]
  private_subnets = [cidrsubnet(local.cidr, 8, 101), cidrsubnet(local.cidr, 8, 102)]

  enable_dns_hostnames = true
  enable_dns_support   = true

}
