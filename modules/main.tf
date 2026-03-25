provider "aws" {
  region  = "ap-south-1"
  profile = "hero-dev" # This matches the name you chose in 'aws configure sso'
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr
  name       = var.project_name
}

module "subnets" {
  source = "./modules/subnets"

  vpc_id = module.vpc.vpc_id
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "igw" {
  source = "modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "nat" {
  source = "modules/nat"

  public_subnet_id = module.subnets.public_subnet_ids[0]
}

module "route_tables" {
  source = "modules/route_tables"

  vpc_id            = module.vpc.vpc_id
  igw_id            = module.igw.igw_id
  nat_gateway_id    = module.nat.nat_id
  public_subnets    = module.subnets.public_subnet_ids
  private_subnets   = module.subnets.private_subnet_ids
}