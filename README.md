```hcl
resource "azurerm_nat_gateway" "nat_gw" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.rg_name
  sku_name                = var.nat_gw_sku
  idle_timeout_in_minutes = var.nat_gw_idle_timeout_in_minutes
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

```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_nat_gateway.nat_gw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.nat_gw_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_nat_gateway_public_ip_prefix_association.nat_gw_pip_prefix](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_prefix_association) | resource |
| [azurerm_subnet_nat_gateway_association.nat_gw_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_nat_gw_to_pip"></a> [associate\_nat\_gw\_to\_pip](#input\_associate\_nat\_gw\_to\_pip) | Whether the module should attempt to add the NAT Gw to a public ip | `bool` | `false` | no |
| <a name="input_associate_nat_gw_to_pip_prefix"></a> [associate\_nat\_gw\_to\_pip\_prefix](#input\_associate\_nat\_gw\_to\_pip\_prefix) | Whether the module should attempt to add the NAT Gw to a public ip prefix | `bool` | `false` | no |
| <a name="input_associate_nat_gw_to_subnet"></a> [associate\_nat\_gw\_to\_subnet](#input\_associate\_nat\_gw\_to\_subnet) | Whether the module should attempt to add the NAT Gw to a subnet | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location for this resource to be put in | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the VNet gateway | `string` | n/a | yes |
| <a name="input_nat_gw_idle_timeout_in_minutes"></a> [nat\_gw\_idle\_timeout\_in\_minutes](#input\_nat\_gw\_idle\_timeout\_in\_minutes) | The number of idle timeout in minutes for the gateway | `number` | `10` | no |
| <a name="input_nat_gw_sku"></a> [nat\_gw\_sku](#input\_nat\_gw\_sku) | The SKU of the nat gateway | `string` | `"Standard"` | no |
| <a name="input_nat_gw_zones"></a> [nat\_gw\_zones](#input\_nat\_gw\_zones) | The zones for the natgw | `list(string)` | <pre>[<br>  "1"<br>]</pre> | no |
| <a name="input_pip_id"></a> [pip\_id](#input\_pip\_id) | The id of a pip, if it is to be associated to the nat gateway | `string` | `null` | no |
| <a name="input_pip_prefix_id"></a> [pip\_prefix\_id](#input\_pip\_prefix\_id) | The id of a pip prefix, if it is to be associated to the nat gateway | `string` | `null` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | A subnet ID to associate the NAT gateway to | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of the tags to use on the resources that are deployed with this module. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gw_id"></a> [nat\_gw\_id](#output\_nat\_gw\_id) | The Id of the nat gw |
| <a name="output_nat_gw_name"></a> [nat\_gw\_name](#output\_nat\_gw\_name) | The name of the nat gw |
| <a name="output_nat_gw_resource_guid"></a> [nat\_gw\_resource\_guid](#output\_nat\_gw\_resource\_guid) | The guid of the nat gw |
| <a name="output_nat_gw_rg_name"></a> [nat\_gw\_rg\_name](#output\_nat\_gw\_rg\_name) | The resource group name of the nat gw |
| <a name="output_nat_gw_tags"></a> [nat\_gw\_tags](#output\_nat\_gw\_tags) | The tags of the nat gw |
