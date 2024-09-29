#This file will include the primary resources for my infrastructure, possibly including my VPC, EKS cluster, and #CodePipeline.

module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = "10.0.0.0/24"
  public_subnet_count = 2
}

