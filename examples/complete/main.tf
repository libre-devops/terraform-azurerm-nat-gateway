locals {
  location    = lookup(var.regions, var.loc, "uksouth")
  rg_name     = "rg-${var.short}-${var.loc}-${terraform.workspace}-001"
  vnet_name   = "vnet-${var.short}-${var.loc}-${terraform.workspace}-001"
  pip_name    = "pip-${var.short}-${var.loc}-${terraform.workspace}-001"
  prefix_name = "ippre-${var.short}-${var.loc}-${terraform.workspace}-001"
  subnet_app  = "snet-app-${var.short}-${var.loc}-${terraform.workspace}-001"
  subnet_data = "snet-data-${var.short}-${var.loc}-${terraform.workspace}-001"
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

  public_ips         = { (local.pip_name) = {} }
  public_ip_prefixes = { (local.prefix_name) = { prefix_length = 30 } }
}

module "network" {
  source  = "libre-devops/network/azurerm"
  version = "~> 4.0"

  resource_group_id = module.rg.ids[local.rg_name]
  location          = local.location
  tags              = module.tags.tags

  vnet_name     = local.vnet_name
  address_space = ["10.60.0.0/24"]
  subnets = {
    (local.subnet_app)  = { address_prefixes = ["10.60.1.0/24"] }
    (local.subnet_data) = { address_prefixes = ["10.60.2.0/24"] }
  }
}

# Complete call: a zonal NAT gateway with a public IP and a public IP prefix, serving both subnets.
module "nat_gateway" {
  source = "../../"

  resource_group_id = module.rg.ids[local.rg_name]
  location          = local.location
  tags              = module.tags.tags

  name  = "ng-${var.short}-${var.loc}-${terraform.workspace}-001"
  zones = ["1"]

  public_ip_associations        = { (local.pip_name) = module.public_ip.public_ip_ids[local.pip_name] }
  public_ip_prefix_associations = { (local.prefix_name) = module.public_ip.public_ip_prefix_ids[local.prefix_name] }
  subnet_associations = {
    (local.subnet_app)  = module.network.subnet_ids[local.subnet_app]
    (local.subnet_data) = module.network.subnet_ids[local.subnet_data]
  }
}
