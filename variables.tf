variable "idle_timeout_in_minutes" {
  description = "TCP idle timeout in minutes (4 to 120)."
  type        = number
  default     = 4

  validation {
    condition     = var.idle_timeout_in_minutes >= 4 && var.idle_timeout_in_minutes <= 120
    error_message = "idle_timeout_in_minutes must be between 4 and 120."
  }
}

variable "location" {
  description = "Azure region for the NAT gateway."
  type        = string
}

variable "name" {
  description = "Name of the NAT gateway."
  type        = string
}

variable "public_ip_associations" {
  description = "Public IPs to attach for outbound, keyed by a logical name with the public IP id as the value (ids may be computed in the same apply; the static keys keep for_each valid). A NAT gateway needs at least one public IP or prefix."
  type        = map(string)
  default     = {}
}

variable "public_ip_prefix_associations" {
  description = "Public IP prefixes to attach for outbound, keyed by a logical name with the prefix id as the value."
  type        = map(string)
  default     = {}
}

variable "resource_group_id" {
  description = "Resource id of the resource group to create the NAT gateway in. The name and subscription are parsed from it (pass the rg module's ids output)."
  type        = string

  validation {
    condition     = try(provider::azurerm::parse_resource_id(var.resource_group_id).resource_type, "") == "resourceGroups"
    error_message = "resource_group_id must be a resource group id of the form /subscriptions/<sub>/resourceGroups/<name>."
  }
}

variable "sku_name" {
  description = "NAT gateway SKU. Standard or StandardV2."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "StandardV2"], var.sku_name)
    error_message = "sku_name must be Standard or StandardV2."
  }
}

variable "subnet_associations" {
  description = "Subnets to attach this NAT gateway to, keyed by subnet name with the subnet id as the value."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the NAT gateway."
  type        = map(string)
  default     = {}
}

variable "zones" {
  description = "Availability zones for the NAT gateway. Standard supports at most one zone; StandardV2 must omit zones (it is zone-redundant by default)."
  type        = list(string)
  default     = []

  validation {
    condition     = var.sku_name == "StandardV2" ? length(var.zones) == 0 : length(var.zones) <= 1
    error_message = "StandardV2 NAT gateways must omit zones; Standard supports at most one zone."
  }
}
