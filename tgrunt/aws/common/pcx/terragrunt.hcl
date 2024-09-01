include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../terraform-modules/vpc-peering-connection"
}

dependency "accepter" {
  config_path = "${get_terragrunt_dir()}/../../main/vpc"
}

dependency "requester" {
  config_path = "${get_terragrunt_dir()}/../../dr/vpc"
}

inputs = {

  ACCEPTER_AWS_ACCESS_KEY_ID     = dependency.accepter.outputs.AWS_ACCESS_KEY_ID
  ACCEPTER_AWS_SECRET_ACCESS_KEY = dependency.accepter.outputs.AWS_SECRET_ACCESS_KEY
  ACCEPTER_AWS_REGION            = dependency.accepter.outputs.AWS_REGION

  REQUESTER_AWS_ACCESS_KEY_ID     = dependency.requester.outputs.AWS_ACCESS_KEY_ID
  REQUESTER_AWS_SECRET_ACCESS_KEY = dependency.requester.outputs.AWS_SECRET_ACCESS_KEY
  REQUESTER_AWS_REGION            = dependency.requester.outputs.AWS_REGION

  requester_vpc_id     = dependency.requester.outputs.vpc_id
  accepter_peer_vpc_id = dependency.accepter.outputs.vpc_id
  accepter_peer_region = dependency.accepter.outputs.AWS_REGION

  accepter_private_route_table_ids = dependency.accepter.outputs.private_route_table_ids
  accepter_public_route_table_ids  = dependency.accepter.outputs.public_route_table_ids
  accepter_vpc_cidr_block          = dependency.accepter.outputs.vpc_cidr_block

  requester_private_route_table_ids = dependency.requester.outputs.private_route_table_ids
  requester_public_route_table_ids  = dependency.requester.outputs.public_route_table_ids
  requester_vpc_cidr_block          = dependency.requester.outputs.vpc_cidr_block

}
