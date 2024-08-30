# AWS VPC with Terraform

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