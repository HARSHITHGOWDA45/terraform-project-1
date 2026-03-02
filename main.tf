module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "asg" {
  source            = "./modules/asg"
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  target_group_arn  = module.alb.target_group_arn
}
