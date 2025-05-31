# Public Subnet (Web) - a
resource "aws_subnet" "public_web_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr-a
  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true # 영문주소 부여
  availability_zone       = "ap-northeast-2a"

  tags = {
    Name = "public-subnet"
  }
}

# Public Subnet (Web) - c
resource "aws_subnet" "public_web_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr-c
  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true # 영문주소 부여
  availability_zone       = "ap-northeast-2c"

  tags = {
    Name = "public-subnet"
  }
}

# WAS Private Subnet (인터넷 가능)
resource "aws_subnet" "private_was" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_was_cidr
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private-was-subnet"
  }
}

# DB Private Subnet (인터넷 차단) - a
resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_db_cidr_a
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private-db-subnet"
  }
}

# DB Private Subnet (인터넷 차단) - c
resource "aws_subnet" "private_db_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_db_cidr_c
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private-db-subnet"
  }
}


# AZ a에 있는 public subnet 연결
resource "aws_route_table_association" "public_assoc_a" {
  subnet_id      = aws_subnet.public_web_a.id
  route_table_id = aws_route_table.public_rt.id
}

# AZ c에 있는 public subnet 연결
resource "aws_route_table_association" "public_assoc_c" {
  subnet_id      = aws_subnet.public_web_c.id
  route_table_id = aws_route_table.public_rt.id
}
