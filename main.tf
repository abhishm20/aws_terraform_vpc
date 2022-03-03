terraform {
   required_providers {
    aws = {
         source = "hashicorp/aws"
         version =  "~> 3.74.2"
    }
    consul = {
      source = "hashicorp/consul"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  profile = "saraloan"
  region  = var.region
}

provider "aws" {
  profile = "saraloan"
  alias  = "cloudfront-acm"
  region = "us-east-1"
}