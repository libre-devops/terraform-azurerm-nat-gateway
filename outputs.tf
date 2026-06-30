output "id" {
  description = "The id of the NAT gateway."
  value       = azurerm_nat_gateway.this.id
}

output "name" {
  description = "The name of the NAT gateway."
  value       = azurerm_nat_gateway.this.name
}

output "nat_gateway" {
  description = "The full azurerm_nat_gateway resource."
  value       = azurerm_nat_gateway.this
}

output "public_ip_association_ids" {
  description = "Map of logical name to public IP association id."
  value       = { for k, a in azurerm_nat_gateway_public_ip_association.this : k => a.id }
}

output "public_ip_prefix_association_ids" {
  description = "Map of logical name to public IP prefix association id."
  value       = { for k, a in azurerm_nat_gateway_public_ip_prefix_association.this : k => a.id }
}

output "resource_group_name" {
  description = "Resource group name parsed from resource_group_id."
  value       = local.resource_group_name
}

output "resource_guid" {
  description = "The resource GUID of the NAT gateway."
  value       = azurerm_nat_gateway.this.resource_guid
}

output "subnet_association_ids" {
  description = "Map of subnet name to subnet NAT gateway association id."
  value       = { for k, a in azurerm_subnet_nat_gateway_association.this : k => a.id }
}

output "subscription_id" {
  description = "Subscription id parsed from resource_group_id."
  value       = local.rg.subscription_id
}
