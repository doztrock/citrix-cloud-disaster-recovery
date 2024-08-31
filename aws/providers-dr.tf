provider "aws" {
  alias      = "dr"
  access_key = var.DR_AWS_ACCESS_KEY_ID
  secret_key = var.DR_AWS_SECRET_ACCESS_KEY
  region     = "us-west-2"
}
