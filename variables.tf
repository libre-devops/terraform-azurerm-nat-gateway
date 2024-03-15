variable "associate_nat_gw_to_pip" {
  type        = bool
  description = "Whether the module should attempt to add the NAT Gw to a public ip"
  default     = false
}

variable "associate_nat_gw_to_pip_prefix" {
  type        = bool
  description = "Whether the module should attempt to add the NAT Gw to a public ip prefix"
  default     = false
}

variable "associate_nat_gw_to_subnet" {
  type        = bool
  description = "Whether the module should attempt to add the NAT Gw to a subnet"
  default     = false
}

variable "location" {
  description = "The location for this resource to be put in"
  type        = string
}

variable "name" {
  type        = string
  description = "The name of the VNet gateway"
}

variable "nat_gw_idle_timeout_in_minutes" {
  type        = number
  description = "The number of idle timeout in minutes for the gateway"
  default     = 10
}

variable "nat_gw_sku" {
  type        = string
  description = "The SKU of the nat gateway"
  default     = "Standard"
}

variable "nat_gw_zones" {
  type        = list(string)
  description = "The zones for the natgw"
  default     = ["1"]
}

variable "pip_id" {
  type        = string
  description = "The id of a pip, if it is to be associated to the nat gateway"
  default     = null
}

variable "pip_prefix_id" {
  type        = string
  description = "The id of a pip prefix, if it is to be associated to the nat gateway"
  default     = null
}

variable "rg_name" {
  description = "The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists"
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "A subnet ID to associate the NAT gateway to"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."
}
