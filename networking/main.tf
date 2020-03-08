#-- networking/main.tf ---

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

#--- VPC 1 - Service Provider

resource "aws_vpc" "vpc1" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { 
    Name = format("%s_vpc1_provider", var.project_name)
    project_name = var.project_name
  }
}

resource "aws_subnet" "subprv1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  
  tags = { 
    Name = format("%s_subprv1", var.project_name)
    project_name = var.project_name
  }
}

resource "aws_subnet" "subprv2" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  
  tags = { 
    Name = format("%s_subprv2", var.project_name)
    project_name = var.project_name
  }
}

# Private route table, allows only local traffic within VPC1
resource "aws_route_table" "rtprv1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = format("%s_rtprv1", var.project_name)
    project_name = var.project_name
  }
}

# # Main Route Tables Associations
# ## Forcing our Route Tables to be the main ones for our VPCs,
# ## otherwise AWS automatically will create a main Route Table
# ## for each VPC, leaving our own Route Tables as secondary
resource "aws_main_route_table_association" "rtprv1assoc" {
  vpc_id         = aws_vpc.vpc1.id
  route_table_id = aws_route_table.rtprv1.id
}

resource "aws_security_group" "sgprv1" {
  name        = "sgprv1"
  description = "Used for access to the public instances"
  vpc_id      = aws_vpc.vpc1.id
  ingress { # allow ping
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = format("%s_sgprv1", var.project_name)
    project_name = var.project_name
  }
}


#--- VPC 2 - Service Consumer

resource "aws_vpc" "vpc2" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { 
    Name = format("%s_vpc2_consumer", var.project_name)
    project_name = var.project_name
  }
}

resource "aws_internet_gateway" "igw2" {
  vpc_id = aws_vpc.vpc2.id

  tags = { 
    Name = format("%s_igw2", var.project_name)
    project_name = var.project_name
  }
}

resource "aws_subnet" "subpub1" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.2.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  
  tags = { 
    Name = format("%s_subpub1", var.project_name)
    project_name = var.project_name
  }
}

# Public route table, allows all outgoing traffic to go the the internet gateway.
# https://www.terraform.io/docs/providers/aws/r/route_table.html?source=post_page-----1a7fb9a336e9----------------------
resource "aws_route_table" "rtpub1" {
  vpc_id = aws_vpc.vpc2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw2.id
  }
  tags = {
    Name = format("%s_rtpub1", var.project_name)
    project_name = var.project_name
  }
}

# Main Route Tables Associations
## Forcing our Route Tables to be the main ones for our VPCs,
## otherwise AWS automatically will create a main Route Table
## for each VPC, leaving our own Route Tables as secondary
resource "aws_main_route_table_association" "rtpub1assoc" {
  vpc_id         = aws_vpc.vpc2.id
  route_table_id = aws_route_table.rtpub1.id
}

resource "aws_security_group" "sgpub1" {
  name        = "sgpub1"
  description = "Used for access to the public instances"
  vpc_id      = aws_vpc.vpc2.id
  ingress { # allow ping
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { # allow ssh
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { # allow http
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = format("%s_sgpub1", var.project_name)
    project_name = var.project_name
  }
}
