module "vpc" {
  
  source = "../modules/vpc"

  vpc_cidr = var.vpc_cidr
  public_cidr = var.public_cidr
  private_cidr = var.private_cidr
  region = var.region
  availability_zones = var.availability_zones
  env_code = var.env_code


}


