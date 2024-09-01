provider "aws" {
  alias      = "accepter"
  access_key = var.ACCEPTER_AWS_ACCESS_KEY_ID
  secret_key = var.ACCEPTER_AWS_SECRET_ACCESS_KEY
  region     = var.ACCEPTER_AWS_REGION
}

provider "aws" {
  alias      = "requester"
  access_key = var.REQUESTER_AWS_ACCESS_KEY_ID
  secret_key = var.REQUESTER_AWS_SECRET_ACCESS_KEY
  region     = var.REQUESTER_AWS_REGION
}
