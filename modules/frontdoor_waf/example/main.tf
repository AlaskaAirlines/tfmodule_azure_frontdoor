provider "azurerm" {
  features {}
}

module "frontdoor_waf" {
  source              = "./.."
  resource_group_name = var.resource_group_name
  frontdoor_wafs      = var.frontdoor_wafs
  custom_rules        = var.custom_rules
  managed_rules       = var.managed_rules
  tags                = var.tags
}
