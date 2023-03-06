variable "my-name" {
  description = "the first name of all created resources by this module"
  default     = "abdo"
}




variable "vpc" {}
data "aws_vpc" "vpc" {
  id = var.vpc
}


variable "public-subnets" {
  type = map(any)
  default = {
    public-subnet = {
      "availability_zone" = "eu-west-2a"
      "cidr_block"        = "10.0.10.0/24"
    }
  }
}



variable "private-subnets" {
  type = map(any)
  default = {
    private-subnet-1 = {
      "availability_zone" = "eu-west-2a"
      "cidr_block"        = "10.0.20.0/24"
    }
    private-subnet-2 = {
      "availability_zone" = "eu-west-2b"
      "cidr_block"        = "10.0.30.0/24"
    }
  }
}


variable "instances" {
  type = map(any)
  default = {
    instance-1 = {
      image = "ami-086b3de06dafe36c5"
    }

    instance-2 = {
      image = "ami-086b3de06dafe36c5"
    }
  }
}


