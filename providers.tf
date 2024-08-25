terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
      configuration_aliases = [
        aws.main, aws.dr
      ]
    }
    citrix = {
      source  = "citrix/citrix"
      version = "1.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "citrix" {
  cvad_config = {
    customer_id   = var.CITRIX_CUSTOMER_ID
    client_id     = var.CITRIX_CLIENT_ID
    client_secret = var.CITRIX_CLIENT_SECRET
  }
}
