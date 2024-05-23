output "vpc_id" {
  value       = aws_vpc.main_vpc.id
  description = "The ID of the VPC created."
}

output "public_subnet_ids" {
  value       = aws_subnet.public_subnet.*.id
  description = "IDs of the public subnets created."
}

output "public_subnet_azs" {
  value = { for s in aws_subnet.public_subnet : s.id => s.availability_zone }
  description = "Availability Zones of the public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnet.*.id
  description = "IDs of the private subnets created."
}

output "private_subnet_azs" {
  value = { for s in aws_subnet.private_subnet : s.id => s.availability_zone }
  description = "Availability Zones of the private subnets"
}