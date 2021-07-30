terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_glue_job" "tf-gluejob" {
  name     = "tf-gluejob"
  role_arn = "arn:aws:iam::152944667076:role/glue_helper"

  command {
    script_location = "s3://mvil-glue/MySQLBYOD.py"
  }
}

resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = "tf-db"
}
