output "nat_gw_id" {
  description = "The Id of the nat gw"
  value       = azurerm_nat_gateway.nat_gw.id
}

output "nat_gw_name" {
  description = "The name of the nat gw"
  value       = azurerm_nat_gateway.nat_gw.name
}

output "nat_gw_resource_guid" {
  description = "The guid of the nat gw"
  value       = azurerm_nat_gateway.nat_gw.resource_guid
}

output "nat_gw_rg_name" {
  description = "The resource group name of the nat gw"
  value       = azurerm_nat_gateway.nat_gw.resource_group_name
}

output "nat_gw_tags" {
  description = "The tags of the nat gw"
  value       = azurerm_nat_gateway.nat_gw.tags
}
