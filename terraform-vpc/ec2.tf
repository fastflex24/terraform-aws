# Create Security Groups
resource "aws_security_group" "public" {
  vpc_id = aws_vpc.main.id

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
}

# Create EC2 Instance in Subnet 2
resource "aws_instance" "sub2_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.sub2.id
  security_groups = [aws_security_group.public.name]
  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "Sub2-Instance"
  }

  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                service httpd start
                chkconfig httpd on
                EOF
}

# Create Auto Scaling Group
resource "aws_launch_configuration" "app" {
  name          = "app-lc"
  image_id       = var.ami_id
  instance_type  = var.instance_type
  security_groups = [aws_security_group.public.name]
  root_block_device {
    volume_size = 20
  }
  
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                service httpd start
                chkconfig httpd on
                EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.id
  min_size             = var.min_asg_size
  max_size             = var.max_asg_size
  vpc_zone_identifier  = [aws_subnet.sub3.id, aws_subnet.sub4.id]
  desired_capacity     = var.min_asg_size

  tag {
    key                 = "Name"
    value               = "ASG-Instance"
    propagate_at_launch = true
  }
}