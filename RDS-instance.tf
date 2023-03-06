#  creating a security group that allow http, https traffic to get into the instance

resource "aws_security_group" "rds-sec-group" {
  name        = "${var.my-name}-security-group2"
  description = "Allow RDS traffic"

  vpc_id = data.aws_vpc.vpc.id
  
  tags = {
    Name = "${var.my-name}-allow-RDS-instance"
  }

  #  allow https, http inbound traffic
  ingress {
    description = "RDS"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  #  allow all outbound traffic from the ec2 instance
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
}


resource "aws_db_subnet_group" "rds-sub-group" {
  name       = "${var.my-name}-sub-group"
  subnet_ids = [aws_subnet.private-subnet["private-subnet-1"].id, aws_subnet.private-subnet["private-subnet-2"].id]

  tags = {
    Name = "${var.my-name}-subnet-group"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 5
  db_name              = "AbdoDB"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "dina"
  password             = "123456abdo"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = "${var.my-name}-sub-group"
  multi_az             = true

  port                   = 3306
  vpc_security_group_ids = [aws_security_group.rds-sec-group.id]
}