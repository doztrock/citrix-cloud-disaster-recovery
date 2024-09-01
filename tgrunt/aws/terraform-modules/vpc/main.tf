data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "available" {
  input        = data.aws_availability_zones.available.names
  result_count = 2
}

module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = var.name
  cidr = var.cidr

  azs             = [element(random_shuffle.available.result, 0), element(random_shuffle.available.result, 1)]
  public_subnets  = [cidrsubnet(var.cidr, 8, 1), cidrsubnet(var.cidr, 8, 2)]
  private_subnets = [cidrsubnet(var.cidr, 8, 101), cidrsubnet(var.cidr, 8, 102)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

}
