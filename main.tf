# A single NAT gateway plus its public IP, public IP prefix, and subnet associations. Public IPs,
# prefixes, and subnets are owned by their own modules; this one associates them by id. Associations
# are keyed by a logical name (static keys), so the ids in the values may be computed in the same
# apply without breaking for_each. The resource group is passed by id and parsed.
locals {
  rg                  = provider::azurerm::parse_resource_id(var.resource_group_id)
  resource_group_name = local.rg.resource_group_name
}

resource "azurerm_nat_gateway" "this" {
  resource_group_name = local.resource_group_name
  location            = var.location
  tags                = var.tags

  name                    = var.name
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = length(var.zones) > 0 ? var.zones : null
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  for_each = var.public_ip_associations

  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = each.value
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "this" {
  for_each = var.public_ip_prefix_associations

  nat_gateway_id      = azurerm_nat_gateway.this.id
  public_ip_prefix_id = each.value
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = var.subnet_associations

  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.this.id
}
