provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "invoiceflow-prod"
  cidr = "10.0.0.0/16"

  azs = ["us-west-1a", "us-west-1c"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "invoiceflow-prod"
  cluster_version = "1.29"
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
   
  access_entries = {
  root = {
    principal_arn = "arn:aws:iam::366451245116:root"
    policy_associations = {
      admin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
}

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      min_size       = 2
      max_size       = 4
      desired_size   = 2
    }
  }
}

resource "aws_ecr_repository" "app" {
  name = "invoiceflow-app"
}

