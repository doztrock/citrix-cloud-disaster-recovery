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
