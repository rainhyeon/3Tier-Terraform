resource "aws_instance" "web_server" {
  ami                    = "ami-0f3a440bbcff3d043"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_web_a.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name               = "hyeon-key"

  tags = {
    Name = "web-server"
  }
}

resource "aws_instance" "was_server" {
  ami                    = "ami-0f3a440bbcff3d043"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_was.id
  vpc_security_group_ids = [aws_security_group.was_sg.id]
  key_name               = "hyeon-key"

  tags = {
    Name = "was-server"
  }
}
