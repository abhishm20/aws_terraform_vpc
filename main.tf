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
  profile = "development"
  region  = var.region
  alias   = "development"
}

provider "aws" {
  profile = "deployment"
  region  = var.region
}

provider "aws" {
  profile = "deployment"
  alias  = "cloudfront-acm"
  region = "us-east-1"
}