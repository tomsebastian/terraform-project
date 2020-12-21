module "variables" {
  source = "../var"
}

resource "aws_vpc" "vpc" {
  cidr_block = module.variables.vpc_cidr

  tags = {
    Name = "${module.variables.name}-vpc"
    Environment = module.variables.environment
    Project = module.variables.project
  }
}

resource "aws_internet_gateway" "igw" {  
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name = "${module.variables.name}-igw"
    Environment = module.variables.environment
    Project = module.variables.project
  }
}

resource "aws_eip" "eip" {
  
  count  = length(module.variables.availability_zones)
  vpc = true
  
  tags = {
    Name = "${element(module.variables.availability_zones, count.index)}-nat-ip"
    Environment = module.variables.environment
    Project = module.variables.project
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(module.variables.availability_zones)
  subnet_id     = element(aws_subnet.public.*.id, count.index)


  allocation_id = element(aws_eip.eip.*.id, count.index)

  tags = {
    Name = "${element(module.variables.availability_zones, count.index)}-nat"
    Environment = module.variables.environment
    Project = module.variables.project
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${module.variables.name}-public-route table"
    Environment = module.variables.environment
    Project = module.variables.project
  }
}

resource "aws_route_table_association" "public" {
  count         = length(module.variables.availability_zones)
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table" "private" {
  count      = length(module.variables.availability_zones)
  vpc_id = aws_vpc.vpc.id

  route {
    
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    Name = "${element(module.variables.availability_zones, count.index)}-private-route table"
    Environment = module.variables.environment
    Project = module.variables.project
  }
}

resource "aws_route_table_association" "private" {
  count         = length(module.variables.availability_zones)
  
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_subnet" "private" {
  count      = length(module.variables.availability_zones)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(module.variables.vpc_cidr, 8, count.index)
  availability_zone = element(module.variables.availability_zones, count.index)
  

  tags = {
    Name = "${element(module.variables.availability_zones, count.index)}-private subnet"
    Environment = module.variables.environment
    Project = module.variables.project
  }
}

resource "aws_subnet" "public" {
  count      = length(module.variables.availability_zones)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(module.variables.vpc_cidr, 8, count.index + length(module.variables.availability_zones))
  availability_zone = element(module.variables.availability_zones, count.index)

  tags = {
    Name = "${element(module.variables.availability_zones, count.index)}-public subnet"
    Environment = module.variables.environment
    Project = module.variables.project
  }
}




