terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-2"
  profile = "george"
}


module "s3"{
  source = "./s3"
}