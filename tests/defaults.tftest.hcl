# Plan-time tests for the module. The azurerm provider is mocked, so no credentials, no
# features block, and no cloud calls are needed:
#   terraform init -backend=false && terraform test

mock_provider "azurerm" {}

variables {
  resource_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ldo-uks-tst-001"
  location          = "uksouth"
  name              = "ng-ldo-uks-tst-001"

  # A valid NAT gateway has at least one public IP and one subnet (the check blocks warn otherwise).
  public_ip_associations = {
    "pip-1" = "/subscriptions/0000/resourceGroups/rg/providers/Microsoft.Network/publicIPAddresses/pip-1"
  }
  subnet_associations = {
    "snet-app" = "/subscriptions/0000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/snet-app"
  }
}

run "creates_nat_gateway_with_secure_defaults" {
  command = plan

  assert {
    condition     = azurerm_nat_gateway.this.sku_name == "Standard" && azurerm_nat_gateway.this.idle_timeout_in_minutes == 4
    error_message = "The NAT gateway should default to Standard SKU with a 4 minute idle timeout."
  }

  assert {
    condition     = output.resource_group_name == "rg-ldo-uks-tst-001"
    error_message = "resource_group_name should be parsed from resource_group_id."
  }
}

run "associations_created_from_maps" {
  command = plan

  variables {
    public_ip_associations = {
      "pip-1" = "/subscriptions/0000/resourceGroups/rg/providers/Microsoft.Network/publicIPAddresses/pip-1"
    }
    subnet_associations = {
      "snet-app" = "/subscriptions/0000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/snet-app"
    }
  }

  assert {
    condition     = length(azurerm_nat_gateway_public_ip_association.this) == 1 && length(azurerm_subnet_nat_gateway_association.this) == 1
    error_message = "Public IP and subnet associations should be created from the maps."
  }
}

run "rejects_standardv2_with_zones" {
  command = plan

  variables {
    sku_name = "StandardV2"
    zones    = ["1"]
  }

  expect_failures = [var.zones]
}

run "rejects_standard_with_multiple_zones" {
  command = plan

  variables {
    zones = ["1", "2"] # sku_name defaults to Standard
  }

  expect_failures = [var.zones]
}

run "rejects_idle_timeout_out_of_range" {
  command = plan

  variables {
    idle_timeout_in_minutes = 200
  }

  expect_failures = [var.idle_timeout_in_minutes]
}
