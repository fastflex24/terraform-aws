variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR block for Subnet 1"
  default     = "10.1.0.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR block for Subnet 2"
  default     = "10.1.1.0/24"
}

variable "subnet3_cidr" {
  description = "CIDR block for Subnet 3"
  default     = "10.1.2.0/24"
}

variable "subnet4_cidr" {
  description = "CIDR block for Subnet 4"
  default     = "10.1.3.0/24"
}

variable "availability_zone1" {
  description = "Availability Zone for Subnet 1 and 2"
  default     = "us-east-1a"
}

variable "availability_zone2" {
  description = "Availability Zone for Subnet 3 and 4"
  default     = "us-east-1b"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the Red Hat Linux instances"
  default     = "ami-0b6f7b81f37edb95e"  # Red Hat Linux AMI ID
}

variable "min_asg_size" {
  description = "Minimum size of the Auto Scaling Group"
  default     = 2
}

variable "max_asg_size" {
  description = "Maximum size of the Auto Scaling Group"
  default     = 6
}