output "AWS_ACCESS_KEY_ID" {
  value = var.AWS_ACCESS_KEY_ID
}

output "AWS_SECRET_ACCESS_KEY" {
  value     = var.AWS_SECRET_ACCESS_KEY
  sensitive = true
}

output "AWS_REGION" {
  value = var.AWS_REGION
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
