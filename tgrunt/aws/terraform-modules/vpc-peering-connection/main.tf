resource "aws_vpc_peering_connection" "this" {
  provider    = aws.requester
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_peer_vpc_id
  peer_region = var.accepter_peer_region
}

resource "aws_vpc_peering_connection_accepter" "this" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = true
}

resource "aws_route" "accepter_private" {
  provider                  = aws.accepter
  count                     = length(var.accepter_private_route_table_ids)
  route_table_id            = var.accepter_private_route_table_ids[count.index]
  destination_cidr_block    = var.requester_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "accepter_public" {
  provider                  = aws.accepter
  count                     = length(var.accepter_public_route_table_ids)
  route_table_id            = var.accepter_public_route_table_ids[count.index]
  destination_cidr_block    = var.requester_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "requester_private" {
  provider                  = aws.requester
  count                     = length(var.requester_private_route_table_ids)
  route_table_id            = var.requester_private_route_table_ids[count.index]
  destination_cidr_block    = var.accepter_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "requester_public" {
  provider                  = aws.requester
  count                     = length(var.requester_public_route_table_ids)
  route_table_id            = var.requester_public_route_table_ids[count.index]
  destination_cidr_block    = var.accepter_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
