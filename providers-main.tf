provider "aws" {
  alias      = "main"
  access_key = var.MAIN_AWS_ACCESS_KEY_ID
  secret_key = var.MAIN_AWS_SECRET_ACCESS_KEY
  region     = "us-east-1"
}
