output "nat_gateway_id" {
  description = "The id of the NAT gateway."
  value       = module.nat_gateway.id
}

output "subnet_association_ids" {
  description = "The subnet NAT gateway association ids."
  value       = module.nat_gateway.subnet_association_ids
}
