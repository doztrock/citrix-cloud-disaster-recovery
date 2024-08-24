provider "aws" {
  alias      = "dr"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = "us-west-2"
}
