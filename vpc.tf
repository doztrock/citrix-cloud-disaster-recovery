locals {
  cidr-main = "10.0.0.0/16"
  azs-main  = ["us-east-1a", "us-east-1b"]
}

module "vpc-main" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "main"
  cidr = local.cidr-main

  azs             = local.azs-main
  public_subnets  = [cidrsubnet(local.cidr-main, 8, 1), cidrsubnet(local.cidr-main, 8, 2)]
  private_subnets = [cidrsubnet(local.cidr-main, 8, 101), cidrsubnet(local.cidr-main, 8, 102)]

  enable_dns_hostnames = true
  enable_dns_support   = true

}
