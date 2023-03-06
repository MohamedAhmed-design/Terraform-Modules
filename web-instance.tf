resource "aws_security_group" "instance-sec-group" {
  name        = "${var.my-name}-security-group1"
  description = "Allow http , https and ssh (inbound traffic)"

  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.my-name}-allow_http_https_ssh"
  }

  #  allow https, http ,ssh inbound traffic
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] ## any source

  }

  ingress {
    description = "HTTPS "
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "ssh "
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  #  allow all outbound traffic from the ec2 instance
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          ## all ports 
    cidr_blocks = ["0.0.0.0/0"] ## any destination 
  }

}



# create multiple EC2 instance with same configuration but different tag name 
resource "aws_instance" "my-instance" {
  for_each = var.instances
  ami      = each.value["image"]

  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.instance-sec-group.id]

  subnet_id = aws_subnet.public-subnet["public-subnet"].id

  key_name = "abdo-london" # this ket pair is already exist with me , in london region used to authenticate when ssh on instances 

  tags = {
    Name = "${var.my-name}-web-${each.key}"
  }
  user_data = <<EOF
      #!/bin/bash
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd
      echo -e '<html>\n<html>\n\t<body>\n\t\t<h1>Welcome To My Website!</h1>\n\t</body>\n</html>' > /var/www/html/index.html
      EOF
}


# Allocate pool of Elastic IPs and attach them to instances 
resource "aws_eip" "my-eip" {
  for_each = aws_instance.my-instance
  instance = each.value.id
  vpc      = true

}
