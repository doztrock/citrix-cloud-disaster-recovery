terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
      configuration_aliases = [
        aws.main, aws.dr
      ]
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}
