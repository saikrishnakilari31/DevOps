output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "db_endpoint" {
  value = aws_db_instance.app_db.address
  sensitive = true
}
