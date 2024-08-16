locals {
  cidr-main = "10.10.0.0/16"
  azs-main  = ["us-east-1a", "us-east-1b"]
  cidr-dr   = "10.20.0.0/16"
  azs-dr    = ["us-west-2a", "us-west-2b"]
}

module "vpc-main" {

  providers = {
    aws = aws.main
  }

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

module "vpc-dr" {

  providers = {
    aws = aws.dr
  }

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "dr"
  cidr = local.cidr-dr

  azs             = local.azs-dr
  public_subnets  = [cidrsubnet(local.cidr-dr, 8, 1), cidrsubnet(local.cidr-dr, 8, 2)]
  private_subnets = [cidrsubnet(local.cidr-dr, 8, 101), cidrsubnet(local.cidr-dr, 8, 102)]

  enable_dns_hostnames = true
  enable_dns_support   = true

}

resource "aws_vpc_peering_connection" "main-dr" {
  provider    = aws.dr
  vpc_id      = module.vpc-dr.vpc_id
  peer_vpc_id = module.vpc-main.vpc_id
  peer_region = "us-east-1"
  depends_on = [
    module.vpc-main, module.vpc-dr
  ]
}

resource "aws_vpc_peering_connection_accepter" "main-dr" {
  provider                  = aws.main
  vpc_peering_connection_id = aws_vpc_peering_connection.main-dr.id
  auto_accept               = true
}
