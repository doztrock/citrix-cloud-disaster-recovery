locals {
  main-azs-private-subnets-cidr-blocks = var.ARE_CC_READY ? zipmap(local.azs-main, module.vpc-main.private_subnets_cidr_blocks) : {}
  dr-azs-private-subnets-cidr-blocks   = var.ARE_CC_READY ? zipmap(local.azs-dr, module.vpc-dr.private_subnets_cidr_blocks) : {}
}

resource "citrix_aws_hypervisor" "main" {
  count      = var.ARE_CC_READY ? 1 : 0
  name       = "main-${data.aws_region.main.name}"
  zone       = citrix_zone.main.id
  api_key    = var.MAIN_AWS_ACCESS_KEY_ID
  secret_key = var.MAIN_AWS_SECRET_ACCESS_KEY
  region     = data.aws_region.main.name
}

resource "citrix_aws_hypervisor_resource_pool" "main" {
  for_each   = local.main-azs-private-subnets-cidr-blocks
  name       = "main-${each.key}"
  hypervisor = citrix_aws_hypervisor.main[0].id
  subnets = [
    each.value
  ]
  vpc               = module.vpc-main.name
  availability_zone = each.key
}

resource "citrix_aws_hypervisor" "dr" {
  count      = var.ARE_CC_READY ? 1 : 0
  name       = "dr-${data.aws_region.dr.name}"
  zone       = citrix_zone.dr.id
  api_key    = var.DR_AWS_ACCESS_KEY_ID
  secret_key = var.DR_AWS_SECRET_ACCESS_KEY
  region     = data.aws_region.dr.name
}

resource "citrix_aws_hypervisor_resource_pool" "dr" {
  for_each   = local.dr-azs-private-subnets-cidr-blocks
  name       = "dr-${each.key}"
  hypervisor = citrix_aws_hypervisor.dr[0].id
  subnets = [
    each.value
  ]
  vpc               = module.vpc-dr.name
  availability_zone = each.key
}
