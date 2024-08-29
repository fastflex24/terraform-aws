// This resource represents the main VPC (Virtual Private Cloud) configuration.
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
}

// This resource represents the first subnet within the VPC.
resource "aws_subnet" "sub1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.subnet1_cidr
    availability_zone       = var.availability_zone1
    map_public_ip_on_launch = true
}

// This resource represents the second subnet within the VPC.
resource "aws_subnet" "sub2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.subnet2_cidr
    availability_zone       = var.availability_zone1
    map_public_ip_on_launch = true
}

// This resource represents the third subnet within the VPC.
resource "aws_subnet" "sub3" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.subnet3_cidr
    availability_zone = var.availability_zone2
}

// This resource represents the fourth subnet within the VPC.
resource "aws_subnet" "sub4" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.subnet4_cidr
    availability_zone = var.availability_zone2
}

// This resource represents the internet gateway attached to the VPC.
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
}

// This resource represents the public route table associated with the VPC.
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
}

// This resource associates the first subnet with the public route table.
resource "aws_route_table_association" "sub1" {
    subnet_id      = aws_subnet.sub1.id
    route_table_id = aws_route_table.public.id
}

// This resource associates the second subnet with the public route table.
resource "aws_route_table_association" "sub2" {
    subnet_id      = aws_subnet.sub2.id
    route_table_id = aws_route_table.public.id
}