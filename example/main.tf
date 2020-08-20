provider "azurerm" {
  features {}
}

module "tfmodule_azure_frontdoor" {
  source                                       = "./.."
  resource_group_name                          = var.resource_group_name
  frontdoor_name                               = var.frontdoor_name
  frontdoor_friendly_name                      = var.frontdoor_friendly_name
  enforce_backend_pools_certificate_name_check = var.enforce_backend_pools_certificate_name_check
  load_balancer_enabled                        = var.load_balancer_enabled
  routing_rules                                = var.routing_rules
  backend_pool_load_balancing_configurations   = var.backend_pool_load_balancing_configurations
  backend_pool_health_probe_configurations     = var.backend_pool_health_probe_configurations
  backend_pools                                = var.backend_pools
  frontend_endpoints                           = var.frontend_endpoints
  frontdoor_wafs                               = var.frontdoor_wafs
  forwarding_configurations                    = var.forwarding_configurations
  redirect_configurations                      = var.redirect_configurations
  custom_rules                                 = var.custom_rules
  managed_rules                                = var.managed_rules
  tags                                         = var.tags
}
