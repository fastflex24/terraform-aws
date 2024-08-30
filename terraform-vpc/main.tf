resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create a Route Table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate the public route table with public subnets
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public.id
}

# Ensure the subnets are marked as public by enabling auto-assign public IP on launch
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.0.0/24"
  availability_zone = "us-east-1a" # adjust as necessary
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet2"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-east-1a" # adjust as necessary
  tags = {
    Name = "subnet3"
  }
}

resource "aws_subnet" "subnet4" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "subnet4"
  }
}

resource "aws_security_group" "sg_public" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

resource "aws_security_group" "sg_private" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

resource "aws_instance" "ec2_instance" {
  ami                     = "ami-007868005aea67c54" # Red Hat Linux AMI
  instance_type           = "t2.micro"
  subnet_id               = aws_subnet.subnet2.id
  vpc_security_group_ids  = [aws_security_group.sg_public.id]
  associate_public_ip_address = true

  tags = {
    Name = "redhat-instance"
  }

  root_block_device {
    volume_size = 20
  }

  user_data = file("scripts/install-httpd.sh")
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration   = aws_launch_configuration.lc.id
  min_size               = 2
  max_size               = 6
  desired_capacity       = 2
  vpc_zone_identifier    = [aws_subnet.subnet3.id, aws_subnet.subnet4.id]

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "lc" {
  image_id                = "ami-007868005aea67c54" # Red Hat Linux AMI
  instance_type           = "t2.micro"
  user_data               = file("scripts/install-httpd.sh")
  iam_instance_profile    = aws_iam_instance_profile.asg_instance_profile.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket" "images" {
  bucket = "images-imab" # adjust name accordingly
}

resource "aws_s3_bucket_lifecycle_configuration" "images_lifecycle" {
  bucket = aws_s3_bucket.images.id

  rule {
    id     = "archive-rule"
    prefix = "memes/"
    status = "Enabled"

    filter {
      prefix = "memes/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "logs-b" # adjust name accordingly
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "active-rule"
    prefix = "active/"
    status = "Enabled"

    filter {
      prefix = "active/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "inactive-rule"
    prefix = "inactive/"
    status = "Enabled"

    filter {
      prefix = "inactive/"
    }

    expiration {
      days = 90
    }
  }
}

resource "aws_iam_role" "asg_role" {
  name = "asg-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "asg_policy" {
  role       = aws_iam_role.asg_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "asg_instance_profile" {
  name = "asg-instance-profile"
  role = aws_iam_role.asg_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}


resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_public.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = false

  tags = {
    Name = "app-load-balancer"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "app-target-group"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
  }

  tags = {
    Name = "app-target-group"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.tg.arn
}