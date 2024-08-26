data "aws_region" "dr" {
  provider = aws.dr
}

locals {
  cidr-dr = "10.20.0.0/16"
  azs-dr  = ["us-west-2a", "us-west-2b"]
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

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

}

resource "aws_vpc_peering_connection" "main-dr" {
  provider    = aws.dr
  vpc_id      = module.vpc-dr.vpc_id
  peer_vpc_id = module.vpc-main.vpc_id
  peer_region = data.aws_region.main.name
  depends_on = [
    module.vpc-main, module.vpc-dr
  ]
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

module "sg-dr-private" {

  providers = {
    aws = aws.dr
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "private"
  description = "Allows access to the resources on both networks"
  vpc_id      = module.vpc-dr.vpc_id

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = module.vpc-dr.vpc_cidr_block
      rule        = "all-all"
    },
    {
      cidr_blocks = module.vpc-main.vpc_cidr_block
      rule        = "all-all"
    }
  ]

  egress_rules = ["all-all"]

}

module "sg-dr-ping" {

  providers = {
    aws = aws.dr
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "ping"
  description = "Allows inbound ICMP"
  vpc_id      = module.vpc-dr.vpc_id

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = "0.0.0.0/0"
      rule        = "all-icmp"
    }
  ]

}

module "sg-dr-public" {

  providers = {
    aws = aws.dr
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "public"
  description = "Allows inbound and outbound traffic to and from the internet"
  vpc_id      = module.vpc-dr.vpc_id

  ingress_with_cidr_blocks = concat([
    {
      cidr_blocks = module.vpc-dr.vpc_cidr_block
      rule        = "all-all"
    },
    {
      cidr_blocks = module.vpc-main.vpc_cidr_block
      rule        = "all-all"
    }
    ],
    [for ingress in var.INGRESS_WITH_CIDR_BLOCKS : {
      cidr_blocks = ingress.cidr_blocks
      rule        = ingress.rule
    }]
  )

  egress_rules = ["all-all"]

}
