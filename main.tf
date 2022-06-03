terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
    }
  }

  cloud {
    organization = var.tfc_organization
    workspaces {
      tags = [var.tfc_workspace_tag]
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

