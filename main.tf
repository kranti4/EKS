# Create VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "myvpc"

  }
}

# Create Subnets
resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sub1"
  }
}

resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "sub2"
  }
}

# Create EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "mycluster"
  subnets         = [aws_subnet.sub1.id, aws_subnet.sub2.id]
  vpc_id          = aws_vpc.myvpc.id
  cluster_version = "1.28"

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3      
      min_capacity     = 1
        
      instance_type = "t2.medium" # adjust as needed
    }
  }
}
