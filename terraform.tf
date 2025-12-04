terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82"
    }
  }
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "ng-java-app-terraform"
    key            = "staging"
    region         = "us-east-1"
    dynamodb_table = "tfstate-dynamo-lock"
    encrypt        = true
  }
}