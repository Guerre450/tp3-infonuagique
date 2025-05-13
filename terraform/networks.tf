resource "aws_vpc" "tp4" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "VPC-tp4"
  }
}

variable "vpc_cidr" {
  type        = string
  description = "Plages d'adresses du VPC"
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Plages d'adresses des sous-réseaux publics"
  default     = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Plages d'adresses des sous-réseaux privés"
  default     = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}




resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.tp4.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "tp4-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.tp4.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "tp4-private-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.tp4.id

  tags = {
    Name = "tp4-igw"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.tp4.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "tp4-rtb-public"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.tp4.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "tp4-rtb-private"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

