#--- root/main.tf ---
provider "aws" {
  region = "eu-west-1"
}

# deploy networking resources
module "networking" {
  source        = "./networking"
  
  project_name  = var.project_name
}

# Deploy Compute Resources
module "compute" {
  source          = "./compute"
  
  project_name    = var.project_name
  key_name        = var.key_name
  public_key_path = var.public_key_path

  vpc1_id         = module.networking.vpc1_id
  subprv1_id      = module.networking.subprv1_id
  subprv2_id      = module.networking.subprv2_id
  sgprv1_id       = module.networking.sgprv1_id
  
  vpc2_id         = module.networking.vpc2_id
  subpub1_id      = module.networking.subpub1_id
  sgpub1_id       = module.networking.sgpub1_id
}
