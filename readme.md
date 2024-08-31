# AWS VPC with Terraform

               +-----------------+
                  |    VPC (10.1.0.0/16)     |
                  |     Name: main-vpc       |
                  +-----------------+
                      |               |
         +------------------+    +------------------+
         |    Public Subnets    |    Private Subnets    |
         |   (10.1.0.0/24)     |    (10.1.2.0/24)     |
         |   (10.1.1.0/24)     |    (10.1.3.0/24)     |
         +------------------+    +------------------+
               |                       |
    +---------------------+      +---------------------+
    |      Internet Gateway      |      Route Table       |
    |         (main-igw)          |    (public-rt)         |
    +---------------------+      +---------------------+
               |                       |
       +---------------------+    +---------------------+
       |    Application Load Balancer (ALB)  |
       |          (app-load-balancer)        |
       +---------------------+    +---------------------+
                   |                       |
    +---------------------+      +---------------------+
    |   EC2 Instances (public-sg)    |   Auto Scaling Group   |
    |        (subnet2)                         |   (asg)                          |
    +---------------------+      +---------------------+
                   |
    +---------------------+
    |     S3 Buckets        |
    |   (images-imab)     |
    |   (logs-b)             |
    +---------------------+
    
    +---------------------+
    | IAM Roles and Profiles|
    |   (asg-role, ec2-role) |
    +---------------------+

## Project Description
This project sets up a simple AWS VPC environment using Terraform. It includes one VPC, four subnets, an Internet Gateway, a route table, and two EC2 instances and 2 S3 buckets.

the structure in terraform-vpc is :
- main.tf for terraform resources
- outputs.tf for logs outputs
- providers.tf for aws provider
- variable.tf for centralized variables

## Setup
1. Install [Terraform](https://www.terraform.io/downloads.html).
2. Configure AWS credentials.

## Running the Terraform Scripts
1. Clone the repository:
   ```sh
   git clone <repository_url>

## How to run the terraform scripts ?

You should have terraform installed and use the commands bellow:
- terraform init
- terraform plan
- terraform apply
if you have a warning message (depends on your terraform version) please write yes then enter
