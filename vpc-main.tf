data "aws_region" "main" {
  provider = aws.main
}

locals {
  cidr-main = "10.10.0.0/16"
  azs-main  = ["us-east-1a", "us-east-1b"]
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

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

}

resource "aws_vpc_peering_connection_accepter" "dr-main" {
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

module "sg-main-private" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "private"
  description = "Allows access to the resources on both networks"
  vpc_id      = module.vpc-main.vpc_id

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = module.vpc-main.vpc_cidr_block
      rule        = "all-all"
    },
    {
      cidr_blocks = module.vpc-dr.vpc_cidr_block
      rule        = "all-all"
    }
  ]

  egress_with_cidr_blocks = [
    {
      cidr_blocks = module.vpc-main.vpc_cidr_block
      rule        = "all-all"
    },
    {
      cidr_blocks = module.vpc-dr.vpc_cidr_block
      rule        = "all-all"
    }
  ]

}

module "sg-main-ssm" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "ssm"
  description = "Allows access to AWS SSM"
  vpc_id      = module.vpc-main.vpc_id

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = module.vpc-main.vpc_cidr_block
      rule        = "https-443-tcp"
    }
  ]

}

module "sg-main-ping" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "ping"
  description = "Allows inbound ICMP"
  vpc_id      = module.vpc-main.vpc_id

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = "0.0.0.0/0"
      rule        = "all-icmp"
    }
  ]

}

module "sg-main-public" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "public"
  description = "Allows inbound and outbound traffic to and from the internet"
  vpc_id      = module.vpc-main.vpc_id

  ingress_with_cidr_blocks = [for ingress in var.INGRESS_WITH_CIDR_BLOCKS : {
    cidr_blocks = ingress.cidr_blocks
    rule        = ingress.rule
  }]

  egress_rules = ["all-all"]

}

resource "aws_vpc_endpoint" "main-ssm" {
  provider            = aws.main
  vpc_id              = module.vpc-main.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.main.name}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc-main.private_subnets
  security_group_ids  = [module.sg-main-ssm.security_group_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "main-ec2messages" {
  provider            = aws.main
  vpc_id              = module.vpc-main.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.main.name}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc-main.private_subnets
  security_group_ids  = [module.sg-main-ssm.security_group_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "main-ssmmessages" {
  provider            = aws.main
  vpc_id              = module.vpc-main.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.main.name}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc-main.private_subnets
  security_group_ids  = [module.sg-main-ssm.security_group_id]
  private_dns_enabled = true
}
