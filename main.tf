locals {
    common_tags = {
      Owner = "Lucian-Curelaru"
      Environment = "Develop"
    }
}

terraform {
  backend "s3" {
    bucket = "lcurelaru-mybucket-test"
    key = "terraform.tfstate"
    region = "eu-central-1"
    profile = "lcurelaru"
  }
}

provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "lcurelaru"
  public_key = file("${path.root}/leha.pub")
}

module "Data" {
  source = "./Data"
}

module "VPC" {
  source = "./VPC"
  common_tags = "${local.common_tags}"
}

module "Network" {
  source = "./Network"
  public_ports = "${module.Data.public_ports}"
  private_ports = "${module.Data.private_ports}"
  common_tags = "${local.common_tags}"
  vpc_id = "${module.VPC.vpc_id}"
  private_subnet_a = "${module.VPC.private_subnet_a}"
  private_subnet_b = "${module.VPC.private_subnet_b}"
  public_subnet_a = "${module.VPC.public_subnet_a}"
  public_subnet_b = "${module.VPC.public_subnet_b}"
}