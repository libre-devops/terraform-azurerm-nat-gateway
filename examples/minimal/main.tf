locals {
  location    = lookup(var.regions, var.loc, "uksouth")
  rg_name     = "rg-${var.short}-${var.loc}-${terraform.workspace}-001"
  vnet_name   = "vnet-${var.short}-${var.loc}-${terraform.workspace}-001"
  pip_name    = "pip-${var.short}-${var.loc}-${terraform.workspace}-001"
  subnet_name = "snet-app-${var.short}-${var.loc}-${terraform.workspace}-001"
}

module "tags" {
  source  = "libre-devops/tags/azurerm"
  version = "~> 4.0"

  cost_centre     = "1888/67"
  owner           = "platform@example.com"
  deployed_branch = var.deployed_branch
  deployed_repo   = var.deployed_repo
}

module "rg" {
  source  = "libre-devops/rg/azurerm"
  version = "~> 4.0"

  resource_groups = [{ name = local.rg_name, location = local.location, tags = module.tags.tags }]
}

module "public_ip" {
  source  = "libre-devops/public-ip/azurerm"
  version = "~> 4.0"

  resource_group_id = module.rg.ids[local.rg_name]
  location          = local.location
  tags              = module.tags.tags

  public_ips = { (local.pip_name) = {} }
}

module "network" {
  source  = "libre-devops/network/azurerm"
  version = "~> 4.0"

  resource_group_id = module.rg.ids[local.rg_name]
  location          = local.location
  tags              = module.tags.tags

  vnet_name     = local.vnet_name
  address_space = ["10.0.0.0/24"]
  subnets       = { (local.subnet_name) = { address_prefixes = ["10.0.1.0/24"] } }
}

# Minimal call: a NAT gateway giving the subnet outbound through the public IP.
module "nat_gateway" {
  source = "../../"

  resource_group_id = module.rg.ids[local.rg_name]
  location          = local.location
  tags              = module.tags.tags

  name = "ng-${var.short}-${var.loc}-${terraform.workspace}-001"

  public_ip_associations = { (local.pip_name) = module.public_ip.public_ip_ids[local.pip_name] }
  subnet_associations    = { (local.subnet_name) = module.network.subnet_ids[local.subnet_name] }
}
