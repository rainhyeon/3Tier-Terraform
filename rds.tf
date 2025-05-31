# rds - subent group 생성성
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_db_a.id,
                aws_subnet.private_db_c.id] 

  tags = {
    Name = "rds-subnet-group"
  }
}

# rds 생성
resource "aws_db_instance" "mysql_rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = "test1234"  # ✅ 테스트용, 나중에 Secret Manager로 분리 권장
  skip_final_snapshot  = true
  publicly_accessible  = false

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  multi_az               = false

  tags = {
    Name = "mysql-rds"
  }
}
