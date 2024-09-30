#VPC module
module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = "10.0.0.0/16"
  public_subnet_count = 2
  private_subnet_count = 2
}

# EKS module
module "eks" {
  source = "./modules/eks"

  cluster_name      = "optimum-eks-cluster"
  node_group_name   = "optimum-node-group"
  subnet_ids        = module.vpc.private_subnet_ids
  desired_capacity   = 2
  max_size          = 3
  min_size          = 1
}


