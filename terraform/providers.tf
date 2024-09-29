# Initialises Terraform providers and sets their version numbers.

terraform {
  backend "s3" {
    bucket = "cloudnative-tf-state"
    key    = "flextube-state"
    region = "us-east-1"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.71.0"
    }
  }

  required_version = ">= 1.5.6"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
