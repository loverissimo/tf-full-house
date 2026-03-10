module "resource_group" {
  source = "./resources/resource_group"

  name     = var.resource_group_name
  location = local.location
}

module "vnet" {
  source = "./resources/vnet"

  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = local.location
}