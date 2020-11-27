provider "aws" {
    region = module.variables.aws_reg
}

resource "aws_key_pair" "keypair1" {
  key_name   = "${module.variables.stack}-keypairs"
  public_key = file(module.variables.ssh_key)
}

module "vpc" {
  source = "./vpc"
}

module "variables" {
  source = "./var"
}