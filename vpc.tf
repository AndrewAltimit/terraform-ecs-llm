resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${local.app_name}-vpc"
  }
}

resource "aws_subnet" "primary" {
  cidr_block = var.primary_subnet_cidr_block
  vpc_id     = aws_vpc.this.id

  tags = {
    Name = "${local.app_name}-primary-subnet"
  }
}

resource "aws_subnet" "secondary" {
  cidr_block = var.secondary_subnet_cidr_block
  vpc_id     = aws_vpc.this.id

  tags = {
    Name = "${local.app_name}-secondary-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id
}