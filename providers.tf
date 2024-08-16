terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
      configuration_aliases = [
        aws.main, aws.dr
      ]
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

provider "aws" {
  alias      = "main"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_REGION
}

provider "aws" {
  alias      = "dr"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = "us-west-2"
}
