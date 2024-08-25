include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../terraform-modules/vpc"
}

locals {
  cidr = "10.10.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]
}

inputs = {

  name = "main"

  cidr = local.cidr
  azs  = local.azs

  public_subnets  = [cidrsubnet(local.cidr, 8, 1), cidrsubnet(local.cidr, 8, 2)]
  private_subnets = [cidrsubnet(local.cidr, 8, 101), cidrsubnet(local.cidr, 8, 102)]

  enable_dns_hostnames = true
  enable_dns_support   = true

}
