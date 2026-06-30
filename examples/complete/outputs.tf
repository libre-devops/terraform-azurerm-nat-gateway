output "nat_gateway_id" {
  description = "The id of the NAT gateway."
  value       = module.nat_gateway.id
}

output "public_ip_association_ids" {
  description = "The public IP association ids."
  value       = module.nat_gateway.public_ip_association_ids
}

output "subnet_association_ids" {
  description = "The subnet NAT gateway association ids."
  value       = module.nat_gateway.subnet_association_ids
}

output "tags" {
  description = "The tags applied to the resources."
  value       = module.tags.tags
}
