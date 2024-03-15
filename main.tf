resource "azurerm_nat_gateway" "nat_gw" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.rg_name
  sku_name                = var.nat_gw_sku
  idle_timeout_in_minutes = var.rg_name
  zones                   = var.nat_gw_zones
  tags                    = var.tags
}

resource "azurerm_subnet_nat_gateway_association" "nat_gw_subnet" {
  count          = var.associate_nat_gw_to_subnet == true ? 1 : 0
  subnet_id      = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gw_pip" {
  count                = var.associate_nat_gw_to_pip == true ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = var.pip_id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_gw_pip_prefix" {
  count               = var.associate_nat_gw_to_pip_prefix == true ? 1 : 0
  nat_gateway_id      = azurerm_nat_gateway.nat_gw.id
  public_ip_prefix_id = var.pip_prefix_id
}

