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

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

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

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

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

resource "aws_route" "main-private-dr" {
  provider                  = aws.main
  count                     = length(module.vpc-main.private_route_table_ids)
  route_table_id            = module.vpc-main.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc-dr.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main-dr.id
}

resource "aws_route" "main-public-dr" {
  provider                  = aws.main
  count                     = length(module.vpc-main.public_route_table_ids)
  route_table_id            = module.vpc-main.public_route_table_ids[count.index]
  destination_cidr_block    = module.vpc-dr.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main-dr.id
}

resource "aws_route" "dr-private-main" {
  provider                  = aws.dr
  count                     = length(module.vpc-dr.private_route_table_ids)
  route_table_id            = module.vpc-dr.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc-main.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main-dr.id
}

resource "aws_route" "dr-public-main" {
  provider                  = aws.dr
  count                     = length(module.vpc-dr.public_route_table_ids)
  route_table_id            = module.vpc-dr.public_route_table_ids[count.index]
  destination_cidr_block    = module.vpc-main.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main-dr.id
}

module "sg-main" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "main"
  description = "Allows access to the machines"
  vpc_id      = module.vpc-main.vpc_id

  ingress_with_cidr_blocks = [for ingress in var.INGRESS_WITH_CIDR_BLOCKS : {
    cidr_blocks = ingress.cidr_blocks
    rule        = ingress.rule
  }]

  egress_rules = ["all-all"]

}

module "sg-dr" {

  providers = {
    aws = aws.dr
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "dr"
  description = "Allows access to the machines"
  vpc_id      = module.vpc-dr.vpc_id

  ingress_with_cidr_blocks = [for ingress in var.INGRESS_WITH_CIDR_BLOCKS : {
    cidr_blocks = ingress.cidr_blocks
    rule        = ingress.rule
  }]

  egress_rules = ["all-all"]

}
