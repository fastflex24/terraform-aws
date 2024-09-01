output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.subnet1.id
}

output "private_subnet_id" {
  value = aws_subnet.subnet2.id
}

output "private_subnet_id_2" {
  value = aws_subnet.subnet3.id
}

output "private_subnet_id_3" {
  value = aws_subnet.subnet4.id
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}