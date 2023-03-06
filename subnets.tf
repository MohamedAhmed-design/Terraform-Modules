# create public subnets 
resource "aws_subnet" "public-subnet" {
  vpc_id = data.aws_vpc.vpc.id ## create subnet in my vpc

  for_each          = var.public-subnets
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name = "${var.my-name}-${each.key}"
  }
}

# create private subnets 
resource "aws_subnet" "private-subnet" {
  for_each = var.private-subnets
  vpc_id   = data.aws_vpc.vpc.id ## create subnet in default vpc 

  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name = "${var.my-name}-${each.key}"
  }
}

## create 3 subnets by one block 

# creating a internet_gateway that will be connected to dina-main-public-subnet

resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.my-name}-gw"
  }
}


resource "aws_route_table" "public-rt" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"                ## coming traffic 
    gateway_id = aws_internet_gateway.gw.id ## out interface 
  }

  tags = {
    Name = "${var.my-name}-public-RT"
  }
}


# associate the route table to the subnet "dina-public-subnet"

resource "aws_route_table_association" "rt_assoc" {

  subnet_id      = aws_subnet.public-subnet["public-subnet"].id
  route_table_id = aws_route_table.public-rt.id
}

