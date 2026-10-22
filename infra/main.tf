module "vpc" {
  source = "./modules/vpc"
}
module "ecr" {
  source = "./modules/ecr"
}
module "ecs" {
  source = "./modules/ecs"
}