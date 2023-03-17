
module "load-balancer" {
  
  source = "../modules/lb"

  vpc_id     = data.terraform_remote_state.level1.outputs.vpc_id
  env_code   = var.env_code
  subnet_ids = data.terraform_remote_state.level1.outputs.public_subnet_ids

}


