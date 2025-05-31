# NAT용 EIP
resource "aws_eip" "nat_eip" {
  vpc = true
}

# NAT Gateway (Public Subnet에 생성)
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_web_a.id

  tags = {
    Name = "nat-gateway"
  }
}

# WAS 전용 NAT 라우팅 테이블
resource "aws_route_table" "private_rt_was" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

# WAS 서브넷만 NAT 연결
resource "aws_route_table_association" "was_assoc" {
  subnet_id      = aws_subnet.private_was.id
  route_table_id = aws_route_table.private_rt_was.id
}